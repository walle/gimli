# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Markup do

  it "should remove yaml front matter if asked to" do
    output = "<p>This should be at the top of the file</p>"

    file = Gimli::MarkupFile.new File.expand_path('../../fixtures/yaml_front_matter.textile', __FILE__)
    markup = Gimli::Markup.new file, true

    markup.render.should == output
  end

  it "should handle textile-converted quotes properly" do
    output = %q(<p>&ldquo;Double&rdquo; and &lsquo;single&rsquo; quotes are handled properly.</p>)

    file = Gimli::MarkupFile.new File.expand_path('../../fixtures/quotes.textile', __FILE__)
    markup = Gimli::Markup.new file, true

    markup.render.should == output
  end
end

