# encoding: utf-8

module Gimli

  module Markup

    # Contains functionality to render html from a markup file
    class Renderer
      # Initialize a new Markup object.
      #
      # @param [Gimli::File] file  The Gimli::File to process
      # @param [Boolean] do_remove_yaml_front_matter Should we remove the front matter?
      # @return [Gimli::Markup]
      def initialize(file, do_remove_yaml_front_matter = false)
        @filename = file.filename
        @name = file.name
        @data = file.data
        @do_remove_yaml_front_matter = do_remove_yaml_front_matter
      end

      # Render the content with Gollum wiki syntax on top of the file's own
      # markup language.
      #
      # @return [String] The formatted data
      def render
        data = @data.dup
        @code = Code.new
        @yaml_frontmatter_remover = YamlFrontmatterRemover.new
        data = @yaml_frontmatter_remover.process(data) if @do_remove_yaml_front_matter
        data = @code.extract(data)
        begin
          data = data.force_encoding('utf-8') if data.respond_to? :force_encoding
          data = GitHub::Markup.render(@filename, data)
          if data.nil?
            raise "There was an error converting #{@name} to HTML."
          end
        rescue Object => e
          data = %{<p class="gimli-error">#{e.message}</p>}
        end
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


