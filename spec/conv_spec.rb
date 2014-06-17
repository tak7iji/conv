# encoding: utf-8

require 'spec_helper'

$VERBOSE=nil

describe Conv do
  it 'Convert xml to xlsx(use --xlsx option)' do
    expect(Conv.run ["-f", "samples/source.xml", "--xlsx"]).to eq('XLSX')
    expect(FileUtils.rm "source.xlsx").to eq(["source.xlsx"])
  end

  it 'Convert xml to xlsx(use -x option)' do
    expect(Conv.run ["-f", "samples/source.xml", "-x"]).to eq('XLSX')
    expect(FileUtils.rm "source.xlsx").to eq(["source.xlsx"])
  end

  it 'Convert xml to csv' do
    expect(Conv.run ["-f", "samples/source.xml"]).to eq('CSV')
    expect(FileUtils.rm "source.csv").to eq(["source.csv"])
  end

  it 'Convert xml to csv|xlsx with output directory' do
    expect(Conv.run ["-f", "samples/source.xml", "-o", "res"]).to eq('CSV')
    expect(Conv.run ["-f", "samples/source.xml", "-o", "res", "-x"]).to eq('XLSX')
    expect(FileUtils.rm_r "res").to eq(['res'])
  end

  it 'Convert csv to xml' do
    expect(Conv.run ["-f", "samples/source.csv"]).to eq('XML')
    expect(FileUtils.rm "source.xml").to eq(["source.xml"])
  end

  it 'Convert xslx to xml' do
    expect(Conv.run ["-f", "samples/source.xlsx"]).to eq('XML')
    expect(FileUtils.rm "source.xml").to eq(["source.xml"])
  end

  it 'Convert xslx to xml with sheet name' do
    expect(Conv.run ["-f", "samples/source.xlsx", "-s", "サンプル"]).to eq('XML')
    expect(FileUtils.rm "source.xml").to eq(["source.xml"])
  end

  it 'Convert csv|xlsx to xml with output directory' do
    expect(Conv.run ["-f", "samples/source.csv", "-o", "res"]).to eq('XML')
    expect(Conv.run ["-f", "samples/source.xlsx", "-o", "res", "-x"]).to eq('XML')
    expect(FileUtils.rm_r "res").to eq(['res'])
  end

  it 'Error occur when file is not exist' do
    expect{Conv.run ["-f", "aaa.csv"]}.to raise_error(Errno::ENOENT)
    expect(File.exist?("aaa.xml")).to be_false
  end

  it 'Command' do
    expect{Conv.run}.to raise_error(ArgumentError)
  end

end
