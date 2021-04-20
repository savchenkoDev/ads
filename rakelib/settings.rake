task :settings do
  ENV['RACK_ENV'] ||= 'development'
  require 'config'
  require_relative '../config/initializers/config'
end
