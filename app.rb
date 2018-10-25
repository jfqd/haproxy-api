# encoding: UTF-8
require 'rubygems'
require 'sinatra'
require 'dotenv/load'
require 'haproxy_manager'

PLAIN_TEXT = {'Content-Type' => 'text/plain'}

configure do
  # http://recipes.sinatrarb.com/p/middleware/rack_commonlogger
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

class String
  def blank?
    self == nil || self == ''
  end
end

class NilClass
  def blank?
    self == nil
  end
end

def haproxy
  @haproxy ||= HAProxyManager::Instance.new(ENV['HAPROXY_SOCKET'] || '/var/run/haproxy.socket')
end

post '/disable' do
  begin
    # authorized user?
    if params[:token].blank? || params[:token] != ENV['APP_TOKEN']
      halt 403, PLAIN_TEXT, "unauthorized\n"
    end
    # url parameter valid?
    if params[:backend].blank? || params[:server].blank?
      halt 422, PLAIN_TEXT, "params missing or unvalid\n"
    end
    
    haproxy.disable(params[:server], params[:backend])
    halt 200, PLAIN_TEXT, "backend of server was disabled\n"
    
  rescue Exception => e
    logger.warn "[haproxy-api Rescue: #{e.message}"
    halt 400, PLAIN_TEXT, e.message
  end
end

post '/enable' do
  begin
    # authorized user?
    if params[:token].blank? || params[:token] != ENV['APP_TOKEN']
      halt 403, PLAIN_TEXT, "unauthorized\n"
    end
    # url parameter valid?
    if params[:backend].blank? || params[:server].blank?
      halt 422, PLAIN_TEXT, "params missing or unvalid\n"
    end
    
    haproxy.enable(params[:server],params[:backend])
    halt 200, PLAIN_TEXT, "backend of server was enabled\n"
    
  rescue Exception => e
    logger.warn "[haproxy-api Rescue: #{e.message}"
    halt 400, PLAIN_TEXT, e.message
  end
end

post '/status' do
  begin
    # authorized user?
    if params[:token].blank? || params[:token] != ENV['APP_TOKEN']
      halt 403, PLAIN_TEXT, "unauthorized\n"
    end
    # url parameter valid?
    if params[:backend].blank? || params[:server].blank?
      halt 422, PLAIN_TEXT, "params missing or unvalid\n"
    end
    
    status = haproxy.stats[params[:backend]][params[:server]]["status"]
    
    halt 200, PLAIN_TEXT, status
    
  rescue Exception => e
    logger.warn "[haproxy-api Rescue: #{e.message}"
    halt 400, PLAIN_TEXT, e.message
  end
end

get '/ping' do
  'pong'
end
