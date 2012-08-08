# encoding: utf-8

require 'gimli/version'
require 'gimli/config'
require 'gimli/setup'
require 'gimli/markupfile'
require 'gimli/converter'
require 'gimli/albino'
require 'gimli/path'
require 'gimli/wkhtmltopdf'

module Gimli

  # Create a config object
  # @example Example usage
  #   config = Gimli.configure |config| do
  #     config.file = './test.md'
  #     config.output_dir = '/tmp'
  #     config.table_of_contents = true
  #   end
  def self.configure
    config = Config.new
    yield config
    config
  end

  # Starts the processing of selected files
  def self.process!(config)
    @files = Path.list_valid(config.file, config.recursive).map { |file| MarkupFile.new(file) }
    Converter.new(@files, config).convert!
  end
end
