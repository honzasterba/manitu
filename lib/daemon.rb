#!/usr/bin/ruby
# default rails environment to development
ENV['RAILS_ENV'] ||= 'development'
# require rails environment file which basically "boots" up rails for this script
require File.join(File.dirname(__FILE__), '..', 'config', 'environment')

SLEEP_TIME = 30

loop do
    Manitu.daemon
    sleep(SLEEP_TIME)
end