# encoding: utf-8

require 'fileutils'

require 'gimli/markup'

module Gimli

  # The class that converts the files
  class Converter

    COVER_FILE_PATH = ::File.expand_path("../../../config/cover.html", __FILE__)

    # Initialize the converter with a File
    # @param [Array] files The list of Gimli::MarkupFile to convert (passing a single file will still work)
    # @param [Gimli::Config] config
    def initialize(files, config)
      @files, @config = files, config

      @stylesheets = []
      parameters = [@config.wkhtmltopdf_parameters]
      parameters << '--cover' << COVER_FILE_PATH if config.cover
      @wkhtmltopdf = Wkhtmltopdf.new parameters.join(' ')
    end

    # Convert the file and save it as a PDF file
    def convert!
      merged_contents = []
      @files.each do |file|
        markup = Markup::Renderer.new file, @config.remove_front_matter
        html = convert_image_urls markup.render, file.filename
        if @config.merge
          html = "<div class=\"page-break\"></div>#{html}" unless merged_contents.empty?
          merged_contents << html
        else
          output_pdf(html, file)
        end
        puts html if @config.debug
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

    # Create the pdf
    # @param [String] html the html input
    # @param [String] filename the name of the output file
    def output_pdf(html, filename)
      html = add_head html
      load_stylesheets
      generate_cover!
      append_stylesheets html
      @wkhtmltopdf.output_pdf html, output_file(filename)
    end

    def add_head(html)
      html = "<html>\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n</head><body>\n#{html}</body></html>"
    end

    # Load the stylesheets to pdfkit loads the default and the user selected if any
    def load_stylesheets
      # Load standard stylesheet
      style = ::File.expand_path("../../../config/style.css", __FILE__)
      @stylesheets << style
      @stylesheets << stylesheet if ::File.exists?(stylesheet)
    end

    def append_stylesheets(html)
      @stylesheets.each do |stylesheet|
        html.gsub!(/<\/head>/, style_tag_for(stylesheet) + '</head>')
      end
    end

    def style_tag_for(stylesheet)
      "<style>#{File.read(stylesheet)}</style>"
    end

    # Returns the selected stylesheet. Defaults to ./gimli.css
    # @return [String]
    def stylesheet
      @config.stylesheet.nil? ? 'gimli.css' : @config.stylesheet
    end

    # Returns the directory where to save the output. Defaults to ./
    # @return [String]
    def output_dir
      output_dir = @config.output_dir.nil? ? Dir.getwd : @config.output_dir
      FileUtils.mkdir_p(output_dir) unless ::File.directory?(output_dir)
      output_dir
    end

    # Generate the name of the output file
    # @return [String]
    # @param [Gimli::MarkupFile] file optionally, specify a file, otherwise use output filename
    def output_file(file = nil)
      if file
        output_filename = file.name
        if !@config.output_filename.nil? && @files.length == 1
          output_filename = @config.output_filename
        end
      else
        output_filename = Time.now.to_s.split(' ').join('_')
        output_filename = @files.last.name if @files.length == 1 || @config.merge
        output_filename = @config.output_filename unless @config.output_filename.nil?
      end

      ::File.join(output_dir, "#{output_filename}.pdf")
    end

    # Generate cover file if optional cover was given
    def generate_cover!
      return unless @config.cover
      cover_file = MarkupFile.new @config.cover
      markup = Markup::Renderer.new cover_file
      html = "<div class=\"cover\">\n#{markup.render}\n</div>"
      append_stylesheets(html)
      html = add_head(html)
      File.open(COVER_FILE_PATH, 'w') do |f|
        f.write html
      end
    end
  end
end

