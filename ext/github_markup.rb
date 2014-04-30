require 'redcarpet'

# Monkey patch github markup to use redcarpet with support for autolinks and tables
module GitHub::Markup
  alias_method :old_render, :render
  def render(filename, content = nil)
    if Regexp.compile("\\.(md|mkdn?|mdwn|mdown|markdown|litcoffee)$") =~ filename
      Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :tables => true).render(content)
    else
      old_render(filename, content)
    end
  end
end