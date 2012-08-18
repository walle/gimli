# encoding: utf-8

module Gimli

  # Class used to load files and determine if they are valid
  class MarkupFile
    attr_reader :filename, :name, :data, :format

    # Accepted formats
    FORMATS = [:markdown, :textile, :rdoc, :org, :creole, :rest, :asciidoc, :pod, :roff, :mediawiki]

    # Initializes the file object. Only reads contents if it's a valid file
    def initialize(filename)
      @filename = filename
      extension = ::File.extname(@filename)
      @format = load_format(extension)
      @name = ::File.basename(@filename, extension)
      @data = ::File.open(@filename, 'rb') { |f| f.read } if valid? && ::File.exists?(@filename)
    end

    # Is the file valid
    # @return [Boolean]
    def valid?
      valid_format? @format
    end

    # Converts the format to a symbol if it's a valid format nil otherwise
    # @param [String] format
    # @return [Symbol|nil]
    def load_format(format)
      case format.to_s
        when /(md|mkdn?|mdown|markdown)$/i
          :markdown
        when /(textile)$/i
          :textile
        when /(rdoc)$/i
          :rdoc
        when /(org)$/i
          :org
        when /(creole)$/i
          :creole
        when /(re?st(\.txt)?)$/i
          :rest
        when /(asciidoc)$/i
          :asciidoc
        when /(pod)$/i
          :pod
        when /(\d)$/i
          :roff
        when /(media)?wiki$/i
          :mediawiki
        else
          nil
      end
    end

    # Checks if the format is a valid one
    # @param [String] format
    # @return [Boolean]
    def valid_format?(format)
      return false if format.nil?

      FORMATS.include? format.to_sym
    end
  end
end

