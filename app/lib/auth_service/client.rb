require_relative 'api'

module AuthService
  class Client
    prepend BasicClient
    include AuthService::Api

    option :url, default: -> { 'http://localhost:9292/v1' }
  end
end