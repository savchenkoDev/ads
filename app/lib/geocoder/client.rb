require_relative 'api'

module Geocoder
  class Client
    prepend BasicClient
    include Geocoder::Api
  
    option :url, default: -> { 'http://localhost:9291/' }
  end
end