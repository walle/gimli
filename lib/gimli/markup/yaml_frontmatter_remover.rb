# encoding: utf-8

module Gimli

  module Markup

    # Class that knows how to remove yaml front matter
    class YamlFrontmatterRemover

      # Removes YAML Front Matter
      # Useful if you want to PDF your Jekyll site.
      def process(data)
        data.gsub /^(---\s*\n.*?\n?)^(---\s*$\n?)/m, ''
      end
    end
  end
end
