# encoding: utf-8

require 'fileutils'

require 'pdfkit'

require 'gimli/markup'

module Gimli

  # The class that communicates with PDFKit
  class Converter

    # Initialize the converter with a File
    # @param [Array] files The list of Gimli::File to convert (passing a single file will still work)
    def initialize(files)
      @files = files
    end

    # Convert the file and save it as a PDF file
    # @param [Boolean] merge if true a single pdf with all input files are created
    def convert!(merge = false)
      merged_contents = []
      @files.each do |file|
        markup = Markup.new file
        html = convert_image_urls markup.render
        if merge
          html = "<div class=\"page-break\"></div>#{html}" unless merged_contents.empty?
          merged_contents << html
        else
          output_pdf(html, file)
        end
      end

      unless merged_contents.empty?
        html = merged_contents.join
        output_pdf(html, nil)
      end
    end

    # Rewrite relative image urls to absolute
    # @param [String] html some html to parse
    # @return [String] the html with all image urls replaced to absolute
    def convert_image_urls(html)
      html.scan(/<img[^>]+src="([^"]+)"/).each do |url|
        html.gsub!(url[0], ::File.expand_path(url[0])) unless url[0] =~ /^https?/
      end

      html
    end

    # Load the pdfkit with html
    # @param [String] html
    # @return [PDFKit]
    def pdf_kit(html)
      kit = PDFKit.new(html)

      load_stylesheets kit

      kit
    end

    # Create the pdf
    # @param [String] html the html input
    # @param [String] filename the name of the output file
    def output_pdf(html, filename)
      kit = pdf_kit(html)
      kit.to_file(output_file(filename))
    end

    # Load the stylesheets to pdfkit loads the default and the user selected if any
    # @param [PDFKit] kit
    def load_stylesheets(kit)
      # Load standard stylesheet
      style = ::File.expand_path("../../../config/style.css", __FILE__)
      kit.stylesheets << style
      kit.stylesheets << stylesheet if ::File.exists?(stylesheet)
    end

    # Returns the selected stylesheet. Defaults to ./gimli.css
    # @return [String]
    def stylesheet
      ARGV.flags.stylesheet? ? ARGV.flags.stylesheet : 'gimli.css'
    end

    # Returns the directory where to save the output. Defaults to ./
    # @return [String]
    def output_dir
      output_dir = ARGV.flags.outputdir? ? ARGV.flags.outputdir : Dir.getwd
      FileUtils.mkdir_p(output_dir) unless ::File.directory?(output_dir)
      output_dir
    end

    # Generate the name of the output file
    # @return [String]
    # @param [Gimli::MarkupFile] file optionally, specify a file, otherwise use output filename
    def output_file(file = nil)
      ::File.join(output_dir, "%s.pdf" % (file ? file.name : @files.last.name))
    end
  end
end

