require 'bundler'
Bundler.setup

require 'rest-client'
require 'sinatra'

base = File.expand_path File.dirname(__FILE__)

Dir[File.join(base, '*.rb')].each do |file|
  require file
end
