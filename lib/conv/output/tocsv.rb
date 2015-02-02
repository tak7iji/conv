# encoding: utf-8

require 'fileutils'
require 'nokogiri'
require 'csv'
require 'cgi'
require 'xlsx_writer'
require 'conv/headers'
require 'conv/output/base'

module Conv::Output
  class ToCsv < Conv::Output::Base

    def initialize argv
      FileUtils.mkdir argv[:o] if ! argv[:o].nil? && ! File.exists?(argv[:o])
      @output_file = "#{argv[:o]+'/' if ! argv[:o].nil? && Dir.exists?(argv[:o])}#{File.basename(argv[:f], '.xml')}.csv"

      @out = CSV.open(@output_file, "wb", :headers => Conv::HEADERS, :write_headers => true, :encoding => 'Shift_JIS')
    end
    
  end
end
