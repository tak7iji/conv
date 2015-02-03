# coding: utf-8

require 'nokogiri'
require 'csv'
require 'cgi'
require 'roo'
require 'conv/headers'
require 'conv/toxml/base'

module Conv::ToXml
  class FromCsv < Conv::ToXml::Base
    def internal_process proc
        CSV.foreach(@argv[:f], {:encoding => 'Shift_JIS:UTF-8', :headers => Conv::HEADERS, :return_headers => false}, &proc)
    end
  end
end