# encoding: utf-8

require 'gimli/version'
require 'gimli/setup'
require 'gimli/file'
require 'gimli/converter'
require 'gimli/albino'

module Gimli

  # Starts the processing of selected files
  def self.process!
    @files = []
    if ARGV.flags.file?
      Gimli.load_file(ARGV.flags.file)
    else
      Dir.glob("*").each do |file|
        Gimli.load_file(file)
      end
    end

    @files.each do |file|
      converter = Converter.new file
      converter.convert!
    end
  end

  # Add file to the files to be converted if it's valid
  # @param [String] file
  def self.load_file(file)
    file = File.new file
    @files << file if file.valid?
  end
end

