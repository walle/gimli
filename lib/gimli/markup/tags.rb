# encoding: utf-8

module Gimli

  module Markup

    # Class that knows how to extract tags and render them
    class Tags

      def initialize
        @tagmap = {}
      end

      # Extract all tags into the tagmap and replace with placeholders.
      #
      # @param [String] data - The raw string data.
      # @return [String] Returns the placeholder's string data.
      def extract(data)
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
      def process(data)
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
    end
  end
end


