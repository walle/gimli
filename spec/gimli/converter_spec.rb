# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Converter do
  it 'should give the correct output_file with none given' do
    file = Gimli::MarkupFile.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new [file]
    mock(converter).output_dir { Dir.getwd }

    converter.output_file.should == File.join(Dir.getwd, "#{name}.pdf")
  end

  it 'should give the correct output_file with one given' do
    file = Gimli::MarkupFile.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new [file]
    mock(converter).output_dir { '/tmp/out' }

    converter.output_file(file).should == "/tmp/out/#{name}.pdf"
  end

  it 'should give the correct output_file when one is set' do
    file = Gimli::MarkupFile.new 'fake'
    output_filename = 'my_file'

    converter = Gimli::Converter.new [file], false, false, false, false, output_filename
    mock(converter).output_dir { Dir.getwd }

    converter.output_file.should == File.join(Dir.getwd, "#{output_filename}.pdf")
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
    converter = Gimli::Converter.new file, false, false, false, false, nil, dir

    mock(File).directory?(dir) { true }

    converter.output_dir.should == dir
  end

  it 'should use default stylesheet if none given' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file

    converter.stylesheet.should == 'gimli.css'
  end

  it 'should use stylesheet if given' do
    file = Gimli::MarkupFile.new 'fake'
    stylesheet = '/home/me/gimli/my-style.css'

    converter = Gimli::Converter.new file, false, false, false, false, nil, nil, stylesheet

    converter.stylesheet.should == stylesheet
  end

  it 'should convert relative image urls to absolute' do
    file = Gimli::MarkupFile.new 'fake'
    filename = 'fixtures/fake.textile'
    dir_string = ::File.dirname(::File.expand_path(filename))
    converter = Gimli::Converter.new file

    html = '<p>foo</p><img src="test.jpg" alt="" /><p>bar</p><img src="test2.jpg" alt="" />'
    valid_html = "<p>foo</p><img src=\"#{File.expand_path('test.jpg', dir_string)}\" alt=\"\" /><p>bar</p><img src=\"#{File.expand_path('test2.jpg', dir_string)}\" alt=\"\" />"

    converter.convert_image_urls(html, filename).should == valid_html
  end

  it 'should not rewrite non relative urls' do
    file = Gimli::MarkupFile.new 'fake'
    filename = '../../fixtures/fake.textile'
    dir_string = ::File.dirname(::File.expand_path(filename))
    converter = Gimli::Converter.new file

    html = '<p>foo</p><img src="https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png" alt="" /><p>bar</p>'

    converter.convert_image_urls(html, filename).should == html
  end

  it 'should work on both absolute and relative images' do
    file = Gimli::MarkupFile.new 'fake'
    filename = '../../fixtures/fake.textile'
    dir_string = ::File.dirname(::File.expand_path(filename))
    converter = Gimli::Converter.new file

    html = '<p>foo</p><img src="test.jpg" alt="" /><p>bar</p><img src="/tmp/test2.jpg" alt="" /> <img src="https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png" alt="" />'
    valid_html = "<p>foo</p><img src=\"#{File.expand_path('test.jpg', dir_string)}\" alt=\"\" /><p>bar</p><img src=\"/tmp/test2.jpg\" alt=\"\" /> <img src=\"https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png\" alt=\"\" />"

    converter.convert_image_urls(html, filename).should == valid_html
  end
end

