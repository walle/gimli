# encoding: utf-8

module Gimli

  # Class that keeps the config parameters
  class Config
    attr_accessor :file, :recursive, :merge, :wkhtmltopdf_parameters, :remove_front_matter, :output_filename, :output_dir, :stylesheet

    # Sets default values
    def initialize
      @recursive = false
      @merge = false
      @page_numbers = false
      @table_of_contents = false
      @remove_front_matter = false
    end
  end
end
