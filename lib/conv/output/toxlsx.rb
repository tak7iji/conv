# encoding: utf-8

require 'fileutils'
require 'nokogiri'
require 'csv'
require 'cgi'
require 'xlsx_writer'
require 'conv/headers'
require 'conv/output/base'

module Conv::Output
  class ToXlsx < Conv::Output::Base
    include Conv::Headers

    def initialize argv
      FileUtils.mkdir argv[:o] if ! argv[:o].nil? && ! File.exists?(argv[:o])
      @output_file = "#{argv[:o]+'/' if ! argv[:o].nil? && Dir.exists?(argv[:o])}#{File.basename(argv[:f], '.xml')}.xlsx"

      @doc = XlsxWriter.new
      @sheet = @doc.add_sheet("Data").tap{|s| s.add_row FromXml::Base::HEADERS }
      @out = self
    end
  end
end
