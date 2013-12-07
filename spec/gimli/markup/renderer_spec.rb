# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Markup::Renderer do

  it "should remove yaml front matter if asked to" do
    output = "<p>This should be at the top of the file</p>"

    file = Gimli::MarkupFile.new File.expand_path('../../../fixtures/yaml_front_matter.textile', __FILE__)
    markup = Gimli::Markup::Renderer.new file, true

    markup.render.should == output
  end

  it "should render html with code blocks including utf-8 strings" do
    output = <<-HTML
<div class="CodeRay">
  <div class="code"><pre>まつもとゆきひろ</pre></div>
</div>
    HTML

    file = Gimli::MarkupFile.new File.expand_path('../../../fixtures/code_block_with_utf8.md', __FILE__)
    markup = Gimli::Markup::Renderer.new file, true

    markup.render.strip.should == output.strip
  end
end

