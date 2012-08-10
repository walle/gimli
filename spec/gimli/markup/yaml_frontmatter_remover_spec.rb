# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'
require './lib/gimli/markup'

describe Gimli::Markup::YamlFrontmatterRemover do

  it 'should remove front matter' do
    data = "---\nlayout: test\n---\n\n\nReal data"
    expected = 'Real data'
    Gimli::Markup::YamlFrontmatterRemover.new.process(data).should == expected
  end

  it 'should not modify string if no front matter exists' do
    data = 'Should not be modified'
    Gimli::Markup::YamlFrontmatterRemover.new.process(data).should == data
  end
end

