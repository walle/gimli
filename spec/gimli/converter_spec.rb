# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Converter do
  it 'should give the correct output_file with none given' do
    file = Gimli::MarkupFile.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new file
    mock(converter).output_dir { Dir.getwd }

    converter.output_file.should == File.join(Dir.getwd, "#{name}.pdf")
  end

  it 'should give the correct output_file with one given' do
    file = Gimli::MarkupFile.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new file
    mock(converter).output_dir { '/tmp/out' }

    converter.output_file.should == "/tmp/out/#{name}.pdf"
  end

  it 'should give the correct output_dir when none given' do
    dir = Dir.getwd

    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    converter.output_dir.should == dir
  end

  it 'should give the correct output_dir when given' do
    dir = '/tmp/out'

    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    mock(ARGV).flags.mock!.outputdir? { true }
    mock(ARGV).flags.mock!.outputdir { dir }
    mock(File).directory?(dir) { true }

    converter.output_dir.should == dir
  end

  it 'should use stylesheet if exists in folder' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    mock(ARGV).flags.mock!.stylesheet? { false }

    converter.stylesheet.should == 'gimli.css'
  end

  it 'should use stylesheet if given' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    style = '/home/me/gimli/my-style.css'

    mock(ARGV).flags.mock!.stylesheet? { true }
    mock(ARGV).flags.mock!.stylesheet { style }

    converter.stylesheet.should == style
  end

  it 'should convert relative image urls to absolute' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    html = '<p>foo</p><img src="test.jpg" alt="" /><p>bar</p><img src="test2.jpg" alt="" />'
    valid_html = "<p>foo</p><img src=\"#{File.expand_path('test.jpg')}\" alt=\"\" /><p>bar</p><img src=\"#{File.expand_path('test2.jpg')}\" alt=\"\" />"

    converter.convert_image_urls(html).should == valid_html
  end

  it 'should not rewrite non relative urls' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    html = '<p>foo</p><img src="https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png" alt="" /><p>bar</p>'

    converter.convert_image_urls(html).should == html
  end

  it 'should work on both absolute and relative images' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    html = '<p>foo</p><img src="test.jpg" alt="" /><p>bar</p><img src="/tmp/test2.jpg" alt="" /> <img src="https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png" alt="" />'
    valid_html = "<p>foo</p><img src=\"#{File.expand_path('test.jpg')}\" alt=\"\" /><p>bar</p><img src=\"/tmp/test2.jpg\" alt=\"\" /> <img src=\"https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png\" alt=\"\" />"

    converter.convert_image_urls(html).should == valid_html
  end
end

