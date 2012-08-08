# encoding: utf-8

require './spec/spec_helper'

require './lib/gimli'

describe Gimli::Wkhtmltopdf do

  it 'should assemble correct command' do
    wkhtmltopdf = Gimli::Wkhtmltopdf.new
    mock(wkhtmltopdf).bin { '"wkhtmltopdf"' }
    args = wkhtmltopdf.command('test.pdf')
    args.size.should == 4
    args.should include '"wkhtmltopdf"'
    args.should include '--quiet'
    args.should include '-'
    args.should include  '"test.pdf"'
  end

end

