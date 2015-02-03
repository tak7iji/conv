# coding: utf-8

require 'nokogiri'
require 'csv'
require 'cgi'
require 'roo'
require 'conv/headers'
require 'conv/toxml/base'

module Conv::ToXml
  class FromXlsx < Conv::ToXml::Base
    def internal_process proc
      Roo::Excelx.new(@argv[:f]).tap{|s| s.default_sheet=@argv[:s] if !@argv[:s].nil?}.each({:headers => true}, &proc)
    end
  end
end