# encoding: utf-8

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

RSpec.configure do |config|
  config.mock_with :rr
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end

