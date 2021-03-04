require_relative './config/environment'
run Rack::URLMap.new("/" => AdsController)