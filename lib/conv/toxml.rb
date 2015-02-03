require 'conv/toxml/fromxlsx'
require 'conv/toxml/fromcsv'

module Conv::ToXml
  def self.process argv
    case File.extname(argv[:f])
    when ".xlsx"
        Conv::ToXml::FromXlsx.new(argv).process
    else
        Conv::ToXml::FromCsv.new(argv).process
    end
  end
end
