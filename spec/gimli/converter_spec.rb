require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Converter do
  it 'should give the correct output_file with none given' do
    file = Gimli::File.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new file
    mock(converter).output_dir { Dir.getwd }

    converter.output_file.should == File.join(Dir.getwd, "#{name}.pdf")
  end

  it 'should give the correct output_file with one given' do
    file = Gimli::File.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new file
    mock(converter).output_dir { '/tmp/out' }

    converter.output_file.should == "/tmp/out/#{name}.pdf"
  end

  it 'should give the correct output_dir when none given' do
    dir = Dir.getwd

    file = Gimli::File.new 'fake'
    converter = Gimli::Converter.new file

    converter.output_dir.should == dir
  end

  it 'should give the correct output_dir when given' do
    dir = '/tmp/out'

    file = Gimli::File.new 'fake'
    converter = Gimli::Converter.new file

    mock(ARGV).flags.mock!.outputdir? { true }
    mock(ARGV).flags.mock!.outputdir { dir }
    mock(File).directory?(dir) { true }

    converter.output_dir.should == dir
  end

  it 'should use stylesheet if exists in folder' do
    file = Gimli::File.new 'fake'
    converter = Gimli::Converter.new file

    mock(ARGV).flags.mock!.stylesheet? { false }

    converter.stylesheet.should == 'gimli.css'
  end

  it 'should use stylesheet if given' do
    file = Gimli::File.new 'fake'
    converter = Gimli::Converter.new file

    style = '/home/me/gimli/my-style.css'

    mock(ARGV).flags.mock!.stylesheet? { true }
    mock(ARGV).flags.mock!.stylesheet { style }

    converter.stylesheet.should == style
  end
end

