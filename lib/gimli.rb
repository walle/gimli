# encoding: utf-8

require 'gimli/version'
require 'gimli/setup'
require 'gimli/markupfile'
require 'gimli/converter'
require 'gimli/albino'
require 'gimli/path'

module Gimli

  # Starts the processing of selected files
  def self.process!(file, recursive = false, merge = false, output_filename = nil, output_dir = nil, stylesheet = nil)


    @files = Path.list_valid(file, recursive).map { |file| MarkupFile.new(file) }
    Converter.new(@files, merge, output_filename, output_dir, stylesheet).convert!
  end
end
