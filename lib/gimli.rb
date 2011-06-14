# encoding: utf-8

require 'gimli/version'
require 'gimli/markupfile'
require 'gimli/converter'
require 'gimli/albino'
require 'gimli/path'
require 'gimli/optionparser'

module Gimli

  # Starts the processing of selected files
  def self.process!
    files = []
    options = Parser.parse!(ARGV)
    
    ARGV.each do |target|
      files += Path.list_valid(target, options[:recursive]).map { |file| MarkupFile.new(file) }
    end
    
    Converter.new(files, options).convert!
  end
end
