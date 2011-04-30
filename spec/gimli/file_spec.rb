# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::File do
  it 'should recognize valid format' do
    file = Gimli::File.new 'fake'
    file.valid_format?('textile').should be_true
  end

  it 'should recognize invalid format' do
    file = Gimli::File.new 'fake'
    file.valid_format?('abc123').should be_false
  end

  it 'should recognize nil as invalid format' do
    file = Gimli::File.new 'fake'
    file.valid_format?(nil).should be_false
  end

  it 'should give the name as the filename without the extension' do
    file = Gimli::File.new 'test.txt'
    file.name.should == File.basename(file.filename, File.extname(file.filename))
  end
end

