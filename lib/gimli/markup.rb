# encoding: utf-8

# This file is based on the markup class in gollum - https://github.com/github/gollum
# (The MIT License)
#
# Copyright (c) Tom Preston-Werner, Rick Olson

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

require 'digest/sha1'

require 'github/markup'
require 'nokogiri'

require 'gimli/markup/yaml_frontmatter_remover'
require 'gimli/markup/code'
require 'gimli/markup/code_block'
require 'gimli/markup/tags'

module Gimli

  # Contains functionality to render html from a markup file
  module Markup

    class Markup
      # Initialize a new Markup object.
      #
      # @param [Gimli::File] file  The Gimli::File to process
      # @param [Boolean] do_remove_yaml_front_matter Should we remove the front matter?
      # @return [Gimli::Markup]
      def initialize(file, do_remove_yaml_front_matter = false)
        @filename = file.filename
        @name = file.name
        @data = file.data
        @format = file.format
        @tagmap = {}
        @codemap = {}
        @premap = {}
        @do_remove_yaml_front_matter = do_remove_yaml_front_matter
      end

      # Render the content with Gollum wiki syntax on top of the file's own
      # markup language.
      #
      # @return [String] The formatted data
      def render
        data = @data.dup
        @code = Code.new
        @tags = Tags.new
        @yaml_frontmatter_remover = YamlFrontmatterRemover.new
        data = @yaml_frontmatter_remover.process(data) if @do_remove_yaml_front_matter
        data = @code.extract(data)
        data = @tags.extract(data)
        begin
          data = data.force_encoding('utf-8') if data.respond_to? :force_encoding
          data = GitHub::Markup.render(@filename, data)
          if data.nil?
            raise "There was an error converting #{@name} to HTML."
          end
        rescue Object => e
          data = %{<p class="gimli-error">#{e.message}</p>}
        end
        data = @tags.process(data)
        data = @code.process(data)

        doc  = Nokogiri::HTML::DocumentFragment.parse(data, 'UTF-8')
        yield doc if block_given?
        data = doc_to_html(doc)

        data.gsub!(/<p><\/p>/, '')
        data
      end

      def doc_to_html(doc)
        doc.to_xhtml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XHTML, :encoding => 'UTF-8')
      end
    end
  end
end

