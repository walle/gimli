# encoding: utf-8

require 'gimli/version'
require 'gimli/setup'
require 'gimli/markupfile'
require 'gimli/converter'
require 'gimli/albino'

module Gimli

  # Starts the processing of selected files
  def self.process!

    if ARGV.flags.version?
      puts "Version: #{Gimli::Version}"
      return
    end

    @files = []
    if ARGV.flags.file?
      target = ARGV.flags.file
      target = File.join(target, '*') if File.directory?(target)
    else
      target = "*"
    end
    
    if ARGV.flags.recursive?
      if target == '*'
        target = Dir.pwd
      end
      target = File.join(target, '**', '*')
    end
    
    Dir.glob(target).each do |file|
      Gimli.load_file(file)
    end

    @files.each do |file|
      converter = Converter.new file
      converter.convert!
    end
  end

  # Add file to the files to be converted if it's valid
  # @param [String] file
  def self.load_file(file)
    file = MarkupFile.new file
    @files << file if file.valid?
  end
end