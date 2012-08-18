# encoding: utf-8

module Gimli

  module Markup

    # Class that knows how to extract code blocks and render them with syntax highlightning
    class Code

      def initialize
        @code_blocks = []
      end

      # Extract all code blocks into the codemap and replace with placeholders.
      #
      # @return [String] Returns the placeholder'd String data.
      def extract(data)
        data.gsub!(/^``` ?([^\r\n]+)?\r?\n(.+?)\r?\n```\r?$/m) do
          id = Digest::SHA1.hexdigest($2)
          @code_blocks << CodeBlock.new(id, $1, $2)
          id
        end
        data
      end

      # Process all code from the codemap and replace the placeholders with the
      # final HTML.
      #
      # @return [String] Returns the marked up String data.
      def process(data)
        return data if data.nil? || data.size.zero? || @code_blocks.size.zero?
        @code_blocks.each do |block|
          data.gsub!(block.id, block.highlighted)
        end
        data
      end
    end
  end
end

