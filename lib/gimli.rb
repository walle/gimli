# encoding: utf-8

require 'gimli/version'
require 'gimli/setup'
require 'gimli/markupfile'
require 'gimli/converter'
require 'gimli/albino'
require 'gimli/path'

module Gimli

  # Starts the processing of selected files
  def self.process!

    if ARGV.flags.version?
      puts "Version: #{Gimli::Version}"
      return
    end
    
    Path.list_valid(ARGV.flags.file, ARGV.flags.recursive?).each do |file|
      converter = Converter.new(MarkupFile.new(file))
      converter.convert!
    end
  end
end