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
cd /usr/local/scr
git clone https://github.com/jfqd/haproxy-api.git
cd haproxy-api
chown www:www /usr/local/var/haproxy-api/log/
bundle
```

Create an `APP_TOKEN` and save it to the `.env` file:

```
ruby -e 'require "digest/sha1";puts "APP_TOKEN=#{Digest::SHA2.hexdigest((Random.rand).to_s)}";' > .env
```

And start the application:

```
su -m www -c 'cd /usr/local/scr/haproxy-api; rackup -p 9292 -D -E production -o 127.0.0.1'
rackup -p 9292 -D -E production -o 127.0.0.1
```

You may wanna create a haproy config with https for it :)

## Usage

Get the status of a server backend:

```
curl --data "token=a-secure-token" \
     --data "backend=backend-name" \
     --data "server=server-name" \
     https://example.com:9292/status
```

Disable a server backend:

```
curl --data "token=a-secure-token" \
     --data "backend=backend-name" \
     --data "server=server-name" \
     https://example.com:9292/disable
```

Enable a server backend:

```
curl --data "token=a-secure-token" \
     --data "backend=backend-name" \
     --data "server=server-name" \
     https://example.com:9292/enable
```

Copyright (c) 2018 Stefan Husch, qutic development.