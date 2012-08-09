# encoding: utf-8

module Gimli

  module Markup

    # Class that knows how to remove yaml front matter
    class YamlFrontmatterRemover

      def initialize(data)
        @data = data
      end

      def process
        @data.gsub /^(---\s*\n.*?\n?)^(---\s*$\n?)/m, ''
      end
    end
  end
end
