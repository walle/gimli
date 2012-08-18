# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Wkhtmltopdf do

  before do
    @wkhtmltopdf = Gimli::Wkhtmltopdf.new
  end

  it 'should assemble correct command' do
    mock(@wkhtmltopdf).bin { '"wkhtmltopdf"' }
    args = @wkhtmltopdf.command('test.pdf')
    args.size.should eq 4
    args.should include '"wkhtmltopdf"'
    args.should include '--quiet'
    args.should include '-'
    args.should include  '"test.pdf"'
  end

  it 'should use which to find wkhtmltopdf first time' do
    mock(@wkhtmltopdf).system("which wkhtmltopdf") { '~/wkhtmltopdf' }
    @wkhtmltopdf.bin.should eq '"~/wkhtmltopdf"'
    @wkhtmltopdf.bin.should eq '"~/wkhtmltopdf"' # Should be cached
  end

  it 'should generate a pdf' do
    mock(IO).popen("\"~/wkhtmltopdf\" --quiet - \"\"", "wb+") { true }
    mock(@wkhtmltopdf).system("which wkhtmltopdf") { '~/wkhtmltopdf' }
    @wkhtmltopdf.output_pdf('', '')
  end
end

