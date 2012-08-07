module Gimli

  # The class that communicates with wkhtmltopdf
  class Wkhtmltopdf

    # Set up options for wkhtmltopdf
    def initialize(options = {})
      @options = normalize_options options
    end

    # Convert the html to pdf and write it to file
    # @param [String] html the html input
    # @param [String] filename the name of the output file
    def output_pdf(html, filename)
      args = command(filename)
      invoke = args.join(' ')

      result = IO.popen(invoke, "wb+") do |pdf|
        pdf.puts(html)
        pdf.close_write
        pdf.gets(nil)
      end
    end

    # Assemble the command to run
    # @param [String] filename the outputed pdf's filename
    # @return [Array] a list of strings that make out the call to wkhtmltopdf
    def command(filename)
      args = [bin]
      args += @options.to_a.flatten.compact
      args << '--quiet'
      args << '-'
      args << filename

      args.map {|arg| %Q{"#{arg.gsub('"', '\"')}"}}
    end

    # Find the wkhtmltopdf binary
    # @return [String] the path to the binary
    def bin
      @bin ||= (`which wkhtmltopdf`).chomp
    end

    # Convert options to the format wkhtmltopdf uses
    # @param [Hash] options the options hash
    # @return [Hash] the hash with new options
    def normalize_options(options)
      normalized_options = {}

      options.each do |key, value|
        next if !value
        normalized_key = "--#{normalize_argument key}"
        normalized_options[normalized_key] = normalize_value(value)
      end
      normalized_options
    end

    # Make sure the arg only contains valid characters
    # @param [String] argument the string to normalize
    def normalize_argument(argument)
      argument.to_s.downcase.gsub(/[^a-z0-9]/,'-')
    end

    # Convert value to string if it's not a true value, true value means a switch parameter
    def normalize_value(value)
      case value
      when TrueClass
        nil
      else
        value.to_s
      end
    end

  end

end
