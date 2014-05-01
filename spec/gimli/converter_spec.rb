# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Converter do
  it 'should give the correct output_file with none given' do
    file = Gimli::MarkupFile.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new [file], Gimli::Config.new
    mock(converter).output_dir { Dir.getwd }

    converter.output_file.should == File.join(Dir.getwd, "#{name}.pdf")
  end

  it 'should give the correct output_file with one given' do
    file = Gimli::MarkupFile.new 'fake'
    name = 'my_file'
    mock(file).name { name }

    converter = Gimli::Converter.new [file], Gimli::Config.new
    mock(converter).output_dir { '/tmp/out' }

    converter.output_file(file).should == "/tmp/out/#{name}.pdf"
  end

  it 'should give the correct output_file when one is set' do
    file = Gimli::MarkupFile.new 'fake'
    output_filename = 'my_file'

    config = Gimli.configure do |c|
      c.output_filename = output_filename
    end

    converter = Gimli::Converter.new [file], config
    mock(converter).output_dir { Dir.getwd }

    converter.output_file(file).should == File.join(Dir.getwd, "#{output_filename}.pdf")
  end

  it 'should give the correct output_dir when none given' do
    dir = Dir.getwd

    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file, Gimli::Config.new

    converter.output_dir.should == dir
  end

  it 'should give the correct output_dir when given' do
    dir = '/tmp/out'

    file = Gimli::MarkupFile.new 'fake'

    config = Gimli.configure do |c|
      c.output_dir = dir
    end

    converter = Gimli::Converter.new file, config

    mock(File).directory?(dir) { true }

    converter.output_dir.should == dir
  end

  it 'should use default stylesheet if none given' do
    file = Gimli::MarkupFile.new 'fake'
    converter = Gimli::Converter.new file, Gimli::Config.new

    converter.stylesheet.should == 'gimli.css'
  end

  it 'should use stylesheet if given' do
    file = Gimli::MarkupFile.new 'fake'
    stylesheet = '/home/me/gimli/my-style.css'

    config = Gimli.configure do |c|
      c.stylesheet = stylesheet
    end

    converter = Gimli::Converter.new file, config

    converter.stylesheet.should == stylesheet
  end

  it 'should convert relative image urls to absolute' do
    file = Gimli::MarkupFile.new 'fake'
    filename = 'fixtures/fake.textile'
    dir_string = ::File.dirname(::File.expand_path(filename))
    converter = Gimli::Converter.new file, Gimli::Config.new

    html = '<p>foo</p><img src="test.jpg" alt="" /><p>bar</p><img src="test2.jpg" alt="" />'
    valid_html = "<p>foo</p><img src=\"#{File.expand_path('test.jpg', dir_string)}\" alt=\"\" /><p>bar</p><img src=\"#{File.expand_path('test2.jpg', dir_string)}\" alt=\"\" />"

    converter.convert_image_urls(html, filename).should == valid_html
  end

  it 'should not rewrite non relative urls' do
    file = Gimli::MarkupFile.new 'fake'
    filename = '../../fixtures/fake.textile'
    dir_string = ::File.dirname(::File.expand_path(filename))
    converter = Gimli::Converter.new file, Gimli::Config.new

    html = '<p>foo</p><img src="https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png" alt="" /><p>bar</p>'

    converter.convert_image_urls(html, filename).should == html
  end

  it 'should work on both absolute and relative images' do
    file = Gimli::MarkupFile.new 'fake'
    filename = '../../fixtures/fake.textile'
    dir_string = ::File.dirname(::File.expand_path(filename))
    converter = Gimli::Converter.new file, Gimli::Config.new

    html = '<p>foo</p><img src="test.jpg" alt="" /><p>bar</p><img src="/tmp/test2.jpg" alt="" /> <img src="https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png" alt="" />'
    valid_html = "<p>foo</p><img src=\"#{File.expand_path('test.jpg', dir_string)}\" alt=\"\" /><p>bar</p><img src=\"/tmp/test2.jpg\" alt=\"\" /> <img src=\"https://d3nwyuy0nl342s.cloudfront.net/images/modules/header/logov3-hover.png\" alt=\"\" />"

    converter.convert_image_urls(html, filename).should == valid_html
  end

  it 'should create a cover file if given cover option' do
    file = Gimli::MarkupFile.new 'fake'
    config = Gimli.configure do |config|
      config.cover = 'fake'
    end
    converter = Gimli::Converter.new file, config
    any_instance_of(Gimli::Markup::Renderer) do |renderer|
      stub(renderer).render { 'fake' }
    end

    FileUtils.rm_f(Gimli::Converter::COVER_FILE_PATH)
    converter.generate_cover!
    File.exists?(Gimli::Converter::COVER_FILE_PATH).should == true
  end
end

