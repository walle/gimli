# encoding: utf-8

require 'fileutils'

require 'pdfkit'

require 'gimli/markup'

module Gimli

  # The class that communicates with PDFKit
  class Converter

    # Initialize the converter with a File
    # @param [Array] files The list of Gimli::MarkupFile to convert (passing a single file will still work)
    # @param [Boolean] merge
    # @param [Boolean] pagenumbers
    # @param [Boolean] remove_front_matter
    # @param [String] output_filename
    # @param [String] output_dir
    # @param [String] stylesheet
    def initialize(files, merge = false, pagenumbers = false, remove_front_matter = false, output_filename = nil, output_dir = nil, stylesheet = nil)
      @files = files
      @merge = merge
      @pagenumbers = pagenumbers
      @remove_front_matter = remove_front_matter
      @output_filename = output_filename
      @output_dir = output_dir
      @stylesheet = stylesheet
    end

    # Convert the file and save it as a PDF file
    def convert!
      merged_contents = []
      @files.each do |file|
        markup = Markup.new file, @remove_front_matter
        html = convert_image_urls markup.render, file.filename
        if @merge
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
    def convert_image_urls(html, filename)
      dir_string = ::File.dirname(::File.expand_path(filename))
      html.scan(/<img[^>]+src="([^"]+)"/).each do |url|
        html.gsub!(url[0], ::File.expand_path(url[0], dir_string)) unless url[0] =~ /^https?/
      end

      html
    end

    # Load the pdfkit with html
    # @param [String] html
    # @return [PDFKit]
    def pdf_kit(html)
      options = {}
      options.merge!({ :footer_right => '[page]/[toPage]' }) if @pagenumbers
      kit = PDFKit.new(html, options)

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
      @stylesheet.nil? ? 'gimli.css' : @stylesheet
    end

    # Returns the directory where to save the output. Defaults to ./
    # @return [String]
    def output_dir
      output_dir = @output_dir.nil? ? Dir.getwd : @output_dir
      FileUtils.mkdir_p(output_dir) unless ::File.directory?(output_dir)
      output_dir
    end

    # Generate the name of the output file
    # @return [String]
    # @param [Gimli::MarkupFile] file optionally, specify a file, otherwise use output filename
    def output_file(file = nil)
      if file
        output_filename = file.name
        if !@output_filename.nil? && @files.length == 1
          output_filename = @output_filename
        end
      else
        output_filename = Time.now.to_s.split(' ').join('_')
        output_filename = @files.last.name if @files.length == 1 || @merge
        output_filename = @output_filename unless @output_filename.nil?
      end

      ::File.join(output_dir, "#{output_filename}.pdf")
    end
  end
end

