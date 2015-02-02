require 'conv/output/tocsv'
require 'conv/output/toxlsx'

module Conv::Output
  def self.createOutput argv
    case argv[:x]
    when true
      Case::Output::ToXlsx.new(argv)
    else
      Case::Output::ToCsv.new(argv)
    end
  end
end