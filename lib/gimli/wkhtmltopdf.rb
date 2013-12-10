module Gimli

  # The class that communicates with wkhtmltopdf
  class Wkhtmltopdf

    # Set up options for wkhtmltopdf
    # @param [String] parameters
    def initialize(parameters = nil)
      @parameters = parameters
    end

    # Convert the html to pdf and write it to file
    # @param [String] html the html input
    # @param [String] filename the name of the output file
    def output_pdf(html, filename)
      args = command(filename)
      invoke = args.join(' ')

      IO.popen(invoke, "wb+") do |pdf|
        pdf.puts(html)
        pdf.close_write
        pdf.gets(nil)
      end
    end

    # Assemble the command to run
    # @param [String] filename the outputed pdf's filename
    # @return [Array] a list of strings that make out the call to wkhtmltopdf
    def command(filename)
      [bin, @parameters, '-', "\"#{filename}\""].compact
    end

    # Find the wkhtmltopdf binary
    # @return [String] the path to the binary
    def bin
      @bin ||= "\"#{(`which wkhtmltopdf`).chomp}\""
    end
  end
end
