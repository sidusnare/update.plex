#!/usr/bin/env ruby
# encoding: utf-8

require 'json'
require 'pp'
require 'curl'
require 'curb'

plexurl="https://plex.tv/api/downloads/1.json"
deburl=''
plexcar={}
version=''

curl = Curl::Easy.new(plexurl.strip)
curl.resolve_mode = :ipv4
curl.ssl_verify_host = 0
curl.follow_location = true
curl.useragent = 'Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0'
curl.http_get
plexvar=JSON.load(curl.body_str)
plexvar['computer']['Linux']['releases'].each do |dat|
  if dat['build'] == 'linux-ubuntu-x86_64'
    if dat['distro'] == 'ubuntu'
      deburl = dat['url']
    end
  end
end
version = plexvar['computer']['Linux']['version']
installed = `/usr/bin/dpkg -l plexmediaserver | grep plexmediaserver | awk '{print($3)}'`.strip
if installed != version
  puts "Plex version, installed #{installed}, available #{version} at #{deburl}"
  x=`wget -O /tmp/plex.deb #{deburl}`
  i=`dpkg -i /tmp/plex.deb`
end
