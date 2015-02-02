require 'conv/output/tocsv'
require 'conv/output/toxlsx'

module Conv::Output
  def self.createOutput argv
    case argv[:x]
    when true
      Conv::Output::ToXlsx.new(argv)
    else
      Conv::Output::ToCsv.new(argv)
    end
  end
end