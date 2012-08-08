# encoding: utf-8

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

RSpec.configure do |config|
  config.mock_with :rr
end

