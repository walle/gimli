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
        @file = file
        @do_remove_yaml_front_matter = do_remove_yaml_front_matter

        @data = file.data
        @code = Code.new
        @yaml_frontmatter_remover = YamlFrontmatterRemover.new
      end

      # Render the content with Gollum wiki syntax on top of the file's own
      # markup language.
      #
      # @return [String] The formatted data
      def render
        prepare_data
        render_data
        post_process_data

        return @data
      end

      private

      # Prepare data for rendering
      def prepare_data
        @data = @yaml_frontmatter_remover.process(@data) if @do_remove_yaml_front_matter
        @data = @data.force_encoding('utf-8') if @data.respond_to? :force_encoding
        @data = @code.extract(@data)
      end

      # Do the markup to html rendering
      def render_data
        begin
          @data = @data.force_encoding('utf-8') if @data.respond_to? :force_encoding
          @data = GitHub::Markup.render(@file.filename, @data)
          if @data.nil?
            raise "There was an error converting #{@file.name} to HTML."
          end
        rescue Object => e
          @data = %{<p class="gimli-error">#{e.message}</p>}
        end
      end

      # Do post processing on data
      def post_process_data
        @data = @code.process(@data)
        doc  = Nokogiri::HTML::DocumentFragment.parse(@data, 'UTF-8')
        @data = doc.to_xhtml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XHTML, :encoding => 'UTF-8')
        @data.gsub!(/<p><\/p>/, '')
      end
    end
  end
end


