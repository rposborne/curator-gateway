require 'bundler'
Bundler.require(:default)

require './lib/gateway'
run Sinatra::Application