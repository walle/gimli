# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::MarkupFile do

  before do
    @file = Gimli::MarkupFile.new 'fake'
  end

  it 'should recognize valid format' do
    @file.valid_format?('textile').should be true
  end

  it 'should recognize invalid format' do
    @file.valid_format?('abc123').should be false
  end

  it 'should recognize nil as invalid format' do
    @file.valid_format?(nil).should be false
  end

  it 'should give the name as the filename without the extension' do
    file = Gimli::MarkupFile.new 'test.txt'
    file.name.should == File.basename(file.filename, File.extname(file.filename))
  end

  it 'should know which formats that are valid' do
    @file.load_format(:md).should eq :markdown
    @file.load_format(:textile).should eq :textile
    @file.load_format(:rdoc).should eq :rdoc
    @file.load_format(:org).should eq :org
    @file.load_format(:creole).should eq :creole
    @file.load_format(:rst).should eq :rest
    @file.load_format(:asciidoc).should eq :asciidoc
    @file.load_format(:pod).should eq :pod
    @file.load_format('1').should eq :roff
    @file.load_format(:mediawiki).should eq :mediawiki
    @file.load_format('fake').should be nil
    @file.load_format(nil).should be nil
  end
end

