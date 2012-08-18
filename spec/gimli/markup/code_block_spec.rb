# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'
require './lib/gimli/markup'

describe Gimli::Markup::CodeBlock do

  it 'should highlight code if language is supplied' do
    code_block = Gimli::Markup::CodeBlock.new('1', 'ruby', 'puts "hi"')
    code_block.highlighted.should include('class="CodeRay"')
    code_block.highlighted.should include('class="delimiter"')
  end

  it 'should highlight code if no language is supplied' do
    code_block = Gimli::Markup::CodeBlock.new('1', nil, 'puts "hi"')
    code_block.highlighted.should include('class="CodeRay"')
  end
end

