require 'fileutils'

require 'pdfkit'

require 'gimli/markup'

module Gimli

  # The class that communicates with PDFKit
  class Converter

    # Initialize the converter with a File
    # @param [Gimli::File] file The file to convert
    def initialize(file)
      @file = file
    end

    # Convert the file and save it as a PDF file
    def convert!
      markup = Markup.new @file
      html = markup.render

      kit = pdf_kit(html)

      kit.to_file(output_file)
    end

    # Load the pdfkit with html
    # @param [String] html
    # @return [PDFKit]
    def pdf_kit(html)
      kit = PDFKit.new(html)

      load_stylesheets kit

      kit
    end

    # Load the stylesheets to pdfkit loads the default and the user selected if any
    # @param [PDFKit] kit
    def load_stylesheets(kit)
      # Load standard stylesheet
      style = ::File.expand_path("../../../config/style.css", __FILE__)
      kit.stylesheets << style

      stylesheet

      kit.stylesheets << stylesheet if ::File.exists?(stylesheet)
    end

    # Returns the selected stylesheet. Defaults to ./gimli.css
    # @return [String]
    def stylesheet
      stylesheet = 'gimli.css'
      stylesheet = ARGV.flags.stylesheet if ARGV.flags.stylesheet?
      stylesheet
    end

    # Returns the directory where to save the output. Defaults to ./
    # @return [String]
    def output_dir
      output_dir = Dir.getwd
      output_dir = ARGV.flags.outputdir if ARGV.flags.outputdir?
      FileUtils.mkdir_p(output_dir) unless ::File.directory?(output_dir)
      output_dir
    end

    # Generate the name of the output file
    # @return [String]
    def output_file
      ::File.join(output_dir, "#{@file.name}.pdf")
    end
  end
end

