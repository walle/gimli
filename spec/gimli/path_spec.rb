# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Path do
  
  it 'should find all files in the current directory, with no specified target, without recursion' do
    Gimli::Path.list_valid(nil, false).length.should == 1
  end
  
  it 'should find all files in all subdirectories, with no specified target, with recursion ' do
    Gimli::Path.list_valid(nil, true).length.should == 4
  end
  
  it 'should find all files in all subdirectories, with a specified directory, with recursion' do
    Gimli::Path.list_valid('./spec', true).length.should == 3
  end
    
  it 'should find one file, with a specified file, without recursion' do
    Gimli::Path.list_valid('README.textile', false).length.should == 1
  end
  
  # What is the sound of one file recursing?
  it 'should find one file, with a specified file, with recursion' do
    Gimli::Path.list_valid('README.textile', true).length.should == 1
  end
  
end