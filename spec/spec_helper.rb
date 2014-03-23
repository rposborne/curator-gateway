require 'rubygems'

ENV["RAILS_ENV"] = 'test'

require 'sinatra/base'
require 'rack/test'
require './lib/gateway'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end