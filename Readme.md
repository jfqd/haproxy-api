# haproxy-api

Web-App to enable or disable haproxy backends.

## Installation on OPNSense

Install ruby and dependencies:

```
pkg install ruby
opnsense-code tools ports
cd /usr/ports/devel/ruby-gems && make install
echo "gem: --no-document" >> /root/.gemrc
gem install bundler
```

Install the application:

```
cd /usr/local/var
git clone https://github.com/jfqd/haproxy-api.git
cd haproxy-api
bundle
chown www:www log
```

Create an `APP_TOKEN` in the `.env` file:

```
ruby -e 'require "digest/sha1";puts "APP_TOKEN=#{Digest::SHA2.hexdigest((Random.rand*10000000000000000).to_s)}";' > .env
```

And start the application:

```
su -m www -c 'cd /usr/local/var/haproxy-api; rackup -p 9292 -D'
```

## Usage

tbd.

Copyright (c) 2018 Stefan Husch, qutic development.