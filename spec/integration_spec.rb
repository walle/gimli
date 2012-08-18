# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

require 'fileutils'

describe 'Integration' do

  it 'should generate files from fixtures' do
    config = Gimli.configure do |c|
      c.file = 'spec/fixtures/integration/'
      c.output_dir = 'spec/tmp'
    end

    Gimli.process! config

    ::File.exists?('spec/tmp/markdown.pdf').should be true
    ::File.exists?('spec/tmp/textile.pdf').should be true
  end

  it 'should generate files from fixtures with aditional parameters' do
    config = Gimli.configure do |c|
      c.file = 'spec/fixtures/integration/'
      c.output_dir = 'spec/tmp/merged'
      c.merge = true
      c.stylesheet = 'spec/fixtures/integration/style.css'
      c.output_filename = 'merged'
    end

    Gimli.process! config

    ::File.exists?('spec/tmp/merged/merged.pdf').should be true
  end

  after do
    ::FileUtils.rm_rf 'spec/tmp'
  end

end
