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
    
    Gimli.gather(ARGV.flags.file, ARGV.flags.recursive?).each do |file|
      converter = Converter.new(MarkupFile.new(file))
      converter.convert!
    end
  end
  
  # return an array of paths to valid markup file matching the passed pattern
  # @param [String] target
  # @param [Bool] recursive
  def self.gather(target, recursive = false)
    if recursive
      target ||= Dir.pwd
      if File.directory?(target)
        target = File.join(target, '**', '*')
      end
    else
      target ||= '*'
      if File.directory?(target)
        target = File.join(target, '*')
      end
    end
    print target
    Dir.glob(target).keep_if { |file| MarkupFile.new(file).valid? }
  end
end