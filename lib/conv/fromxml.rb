require 'conv/fromxml/base'
require 'conv/fromxml/tocsv'
require 'conv/fromxml/toxlsx'

module Conv::FromXml
  def self.process argv
    case argv[:x]
    when 'XLSX'
      Conv::FromXml:ToXlsx.new(argv).process
    when 'CSV'
      Conv::FromXml:ToCsv.new(argv).process
    end
  end
end
