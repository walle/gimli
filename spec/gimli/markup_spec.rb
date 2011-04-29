require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Markup do

  it 'should give correct code block' do

    output = "<p>a</p>\n<div class=\"highlight\"><pre>" +
             "<span class=\"n\">x</span> <span class=\"o\">=</span> " +
             "<span class=\"mi\">1</span>\n</pre>\n</div>\n\n<p>b</p>"

    file = Gimli::File.new File.expand_path('../../fixtures/code_block.textile', __FILE__)
    markup = Gimli::Markup.new file

    markup.render.should == output
  end


end

