# encoding: utf-8

require 'gimli/version'
require 'gimli/config'
require 'gimli/setup'
require 'gimli/markupfile'
require 'gimli/converter'
require 'gimli/path'
require 'gimli/wkhtmltopdf'

require 'json'

require File.expand_path(File.dirname(__FILE__)) + '/../ext/github_markup.rb'

module Gimli

  # look for an ordering file to use.  Probably a little nicer for the name of this file
  # to be on a config flag.
  if (File.exists?('order.json'))
    puts "Ordering file found"
    @ordering = JSON.parse(File.read('order.json'))
  else
    @ordering = nil
  end

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

  # find the ordering index for the given filename (without extension). If the ordering file
  # was nil then we just return 0 for every file. Otherwise we lookup the file name, returning -1
  # if it does not have an index in the order array.
  def self.find_index(name)
    if (@ordering == nil)
     0
    else
     @ordering.find_index(name) || -1
    end
  end

  # Starts the processing of selected files
  def self.process!(config)
    @files = Path.list_valid(config.file, config.recursive).map { |file| MarkupFile.new(file) }
    @files.sort! { |left, right| self.find_index(left.name) <=> self.find_index(right.name) }
    # here we filter out files that did not have an entry in the ordering array. this could possibly
    # go on a config flag.
    @files.select! { |v| self.find_index(v.name) != -1 }
    Converter.new(@files, config).convert!
  end
end

