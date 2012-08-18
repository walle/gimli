# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'
require './lib/gimli/markup'

describe Gimli::Markup::Code do

  before do
    @code = Gimli::Markup::Code.new
  end

  it 'should extract code block with language' do
    language = 'ruby'
    code = "\tputs 'hi'"
    markup = "```#{language}\n#{code}\n```"
    @code.extract(markup)
    code_block = @code.instance_variable_get("@code_blocks").first
    code_block.id.should eq Digest::SHA1.hexdigest(code)
    code_block.language.should eq language
    code_block.code.should eq code
  end

  it 'should extract code block without language' do
    code = "\tputs 'hi'"
    markup = "```\n#{code}\n```"
    @code.extract(markup)
    code_block = @code.instance_variable_get("@code_blocks").first
    code_block.id.should eq Digest::SHA1.hexdigest(code)
    code_block.language.should be nil
    code_block.code.should eq code
  end

  it 'should process markup and give back code from id' do
    language = 'ruby'
    code = "\tputs 'hi'"
    id = Digest::SHA1.hexdigest(code)
    markup = "```#{language}\n#{code}\n```"
    markup = @code.extract(markup)
    code_block = @code.instance_variable_get("@code_blocks").first
    @code.process(markup).should eq code_block.highlighted
  end
end

