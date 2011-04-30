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
require 'cgi'

require 'github/markup'
require 'nokogiri'

module Gimli

  # Contains functionality to render html from a markup file
  class Markup
    # Initialize a new Markup object.
    #
    # @param [Gimli::File] file  The Gimli::File to process
    # @return [Gimli::Markup]
    def initialize(file)
      @filename = file.filename
      @name = file.name
      @data = file.data
      @format = file.format
      @tagmap = {}
      @codemap = {}
      @premap = {}
    end

    # Render the content with Gollum wiki syntax on top of the file's own
    # markup language.
    #
    # @return [String] The formatted data
    def render
      data = extract_code(@data.dup)
      data = extract_tags(data)
      begin
        data = GitHub::Markup.render(@filename, data.force_encoding('utf-8'))
        if data.nil?
          raise "There was an error converting #{@name} to HTML."
        end
      rescue Object => e
        data = %{<p class="gimli-error">#{e.message}</p>}
      end
      data = process_tags(data)
      data = process_code(data)

      doc  = Nokogiri::HTML::DocumentFragment.parse(data.force_encoding('utf-8'))
      yield doc if block_given?
      data = doc_to_html(doc)

      data.gsub!(/<p><\/p>/, '')
      data
    end

    def doc_to_html(doc)
      doc.to_xhtml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XHTML)
    end

    # Extract all tags into the tagmap and replace with placeholders.
    #
    # @param [String] data - The raw string data.
    # @return [String] Returns the placeholder's string data.
    def extract_tags(data)
      data.gsub!(/(.?)\[\[(.+?)\]\]([^\[]?)/m) do
        if $1 == "'" && $3 != "'"
          "[[#{$2}]]#{$3}"
        elsif $2.include?('][')
          if $2[0..4] == 'file:'
            pre = $1
            post = $3
            parts = $2.split('][')
            parts[0][0..4] = ""
            link = "#{parts[1]}|#{parts[0].sub(/\.org/,'')}"
            id = Digest::SHA1.hexdigest(link)
            @tagmap[id] = link
            "#{pre}#{id}#{post}"
          else
            $&
          end
        else
          id = Digest::SHA1.hexdigest($2)
          @tagmap[id] = $2
          "#{$1}#{id}#{$3}"
        end
      end
      data
    end

    # Process all tags from the tagmap and replace the placeholders with the
    # final markup.
    #
    # @param [String] data - The data (with placeholders)
    # @return [String] Returns the marked up String data.
    def process_tags(data)
      @tagmap.each do |id, tag|
        data.gsub!(id, process_tag(tag))
      end
      data
    end

    # Process a single tag into its final HTML form.
    #
    # @param [String] tag The String tag contents (the stuff inside the double brackets).
    # @return [String] Returns the String HTML version of the tag.
    def process_tag(tag)
      if html = process_image_tag(tag)
        html
      elsif html = process_file_link_tag(tag)
        html
      end
    end

    # Attempt to process the tag as an image tag.
    #
    # @param [String] tag The String tag contents (the stuff inside the double brackets).
    # @return [String|nil] Returns the String HTML if the tag is a valid image tag or nil if it is not.
    def process_image_tag(tag)
      parts = tag.split('|')
      return if parts.size.zero?

      name  = parts[0].strip
      path  = name

      if path
        opts = parse_image_tag_options(tag)

        containered = false

        classes = [] # applied to whatever the outermost container is
        attrs   = [] # applied to the image

        align = opts['align']
        if opts['float']
          containered = true
          align ||= 'left'
          if %w{left right}.include?(align)
            classes << "float-#{align}"
          end
        elsif %w{top texttop middle absmiddle bottom absbottom baseline}.include?(align)
          attrs << %{align="#{align}"}
        elsif align
          if %w{left center right}.include?(align)
            containered = true
            classes << "align-#{align}"
          end
        end

        if width = opts['width']
          if width =~ /^\d+(\.\d+)?(em|px)$/
            attrs << %{width="#{width}"}
          end
        end

        if height = opts['height']
          if height =~ /^\d+(\.\d+)?(em|px)$/
            attrs << %{height="#{height}"}
          end
        end

        if alt = opts['alt']
          attrs << %{alt="#{alt}"}
        end

        attr_string = attrs.size > 0 ? attrs.join(' ') + ' ' : ''

        if opts['frame'] || containered
          classes << 'frame' if opts['frame']
          %{<span class="#{classes.join(' ')}">} +
          %{<span>} +
          %{<img src="#{path}" #{attr_string}/>} +
          (alt ? %{<span>#{alt}</span>} : '') +
          %{</span>} +
          %{</span>}
        else
          %{<img src="#{path}" #{attr_string}/>}
        end
      end
    end

    # Parse any options present on the image tag and extract them into a
    # Hash of option names and values.
    #
    # @param [String] tag The String tag contents (the stuff inside the double brackets).
    # @return [Hash]
    # Returns the options Hash:
    #   key - The String option name.
    #   val - The String option value or true if it is a binary option.
    def parse_image_tag_options(tag)
      tag.split('|')[1..-1].inject({}) do |memo, attr|
        parts = attr.split('=').map { |x| x.strip }
        memo[parts[0]] = (parts.size == 1 ? true : parts[1])
        memo
      end
    end

    # Extract all code blocks into the codemap and replace with placeholders.
    #
    # @param [String] data The raw String data.
    # @return [String] Returns the placeholder'd String data.
    def extract_code(data)
      data.gsub!(/^``` ?([^\r\n]+)?\r?\n(.+?)\r?\n```\r?$/m) do
        id     = Digest::SHA1.hexdigest($2)
        cached = check_cache(:code, id)
        @codemap[id] = cached   ?
          { :output => cached } :
          { :lang => $1, :code => $2 }
        id
      end
      data
    end

    # Process all code from the codemap and replace the placeholders with the
    # final HTML.
    #
    # @param [String] data The String data (with placeholders).
    # @return [String] Returns the marked up String data.
    def process_code(data)
      return data if data.nil? || data.size.zero? || @codemap.size.zero?

      blocks    = []
      @codemap.each do |id, spec|
        next if spec[:output] # cached

        code = spec[:code]
        if code.lines.all? { |line| line =~ /\A\r?\n\Z/ || line =~ /^(  |\t)/ }
          code.gsub!(/^(  |\t)/m, '')
        end

        blocks << [spec[:lang], code]
      end

      highlighted = begin
        blocks.size.zero? ? [] : Gimli::Albino.colorize(blocks)
      rescue ::Albino::ShellArgumentError, ::Albino::TimeoutExceeded,
               ::Albino::MaximumOutputExceeded
        []
      end

      @codemap.each do |id, spec|
        body = spec[:output] || begin
          if (body = highlighted.shift.to_s).size > 0
            update_cache(:code, id, body)
            body
          else
            "<pre><code>#{CGI.escapeHTML(spec[:code])}</code></pre>"
          end
        end
        data.gsub!(id, body)
      end

      data
    end

    # Hook for getting the formatted value of extracted tag data.
    #
    # @param [Symbol] type Symbol value identifying what type of data is being extracted.
    # @param [String] id String SHA1 hash of original extracted tag data.
    # @return [String] Returns the String cached formatted data, or nil.
    def check_cache(type, id)
    end

    # Hook for caching the formatted value of extracted tag data.
    #
    # @param [Symbol] type Symbol value identifying what type of data is being extracted.
    # @param [String] id String SHA1 hash of original extracted tag data.
    # @param [String] data The String formatted value to be cached.
    # @return [nil]
    def update_cache(type, id, data)
    end
  end
end

