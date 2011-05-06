# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Markup do

  it 'should give correct code block' do

    output_with_pygments = "<p>a</p>\n<div class=\"highlight\"><pre>" +
             "<span class=\"n\">x</span> <span class=\"o\">=</span> " +
             "<span class=\"mi\">1</span>\n</pre>\n</div>\n\n<p>b</p>"

    output_without_pygments = "<p>a</p>\n<pre><code>x = 1</code></pre>\n<p>b</p>"

    file = Gimli::File.new File.expand_path('../../fixtures/code_block.textile', __FILE__)
    markup = Gimli::Markup.new file

    # Check if the html seems to be highlighted
    if markup.render.include? "<div class=\"highlight\">"
      markup.render.should == output_with_pygments
    else
      markup.render.should == output_without_pygments
    end
  end

  it 'should give correct code block for utf8' do

    output_with_pygments = "<p>a</p>\n<div class=\"highlight\"><pre>" +
                           "<span class=\"nt\">&lt;h1&gt;</span>Abc&#xC3;&#xA5;&#xC3;&#xA4;&#xC3;&#xB6;<span class=\"nt\">&lt;/h1&gt;</span>\n" +
                           "<span class=\"nt\">&lt;img</span> <span class=\"na\">src=</span><span class=\"s\">\"&#xC3;&#xA5;&#xC3;&#xA4;&#xC3;&#xB6;.png\"" +
                           "</span> <span class=\"na\">alt=</span><span class=\"s\">\"&#xC3;&#x85;&#xC3;&#x84;&#xC3;&#x96;\"" +
                           "</span> <span class=\"nt\">/&gt;</span>\n</pre>\n</div>\n"

    output_without_pygments = "<p>a</p>\n<pre><code>&lt;h1&gt;Abc&#xE5;&#xE4;&#xF6;&lt;/h1&gt;\n&lt;" +
                              "img src=\"&#xE5;&#xE4;&#xF6;.png\" alt=\"&#xC5;&#xC4;&#xD6;\" /&gt;</code></pre>"

    file = Gimli::File.new File.expand_path('../../fixtures/code_block_with_utf8.textile', __FILE__)
    markup = Gimli::Markup.new file

    # Check if the html seems to be highlighted
    if markup.render.include? "<div class=\"highlight\">"
      markup.render.should == output_with_pygments
    else
      markup.render.should == output_without_pygments
    end
  end

  it 'should give correct code for utf8' do

    output = "<p>a</p>\n<code>&lt;img src=\"&#xE5;&#xE4;&#xF6;.png\" " +
             "alt=\"Abc&#xE5;&#xE4;&#xF6;\" /&gt;</code>\n<p>b</p>"

    file = Gimli::File.new File.expand_path('../../fixtures/code_with_utf8.textile', __FILE__)
    markup = Gimli::Markup.new file

    markup.render.should == output
  end

end

