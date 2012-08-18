# encoding: utf-8

require 'coderay'

module Gimli

  module Markup

    # Class that contains data for a code block
    class CodeBlock
      attr_reader :id, :language, :code

      def initialize(id, language, code)
        @id, @language, @code = id, language, code
      end

      def highlighted
        if @language
          CodeRay.scan(@code, @language).html(:line_numbers => :table)
        else
          CodeRay.scan(@code, :text).div
        end
      end
    end
  end
end


