#encoding: utf-8

require "conv/version"
require "conv/toxml"
require "conv/fromxml"
require "optparse"

Version = Conv::VERSION

module Conv
  def self.run argv
    opts = {}
    opt = OptionParser.new

    begin
      opt.on("-f FILE_NAME", "FILE_NAME must have the following extension: .csv, .xlsx, .xml") {|v| opts[:f] = v}
      opt.on("-x", "--xlsx") {|v| opts[:x] = v}
      opt.on("-o [OUTPUT_DIR]") {|v| opts[:o] = v}
      opt.on("-s [SHEET_NAME]") {|v| opts[:s] = v}
      opt.parse!(argv)

      case File.extname(opts[:f])
      when ".xml"
        out = opts[:x] ? 'XLSX' : 'CSV'
        puts "Convert #{opts[:f]} to #{out}."
        FromXml::Base.new(opts).process
        out
      when ".csv", ".xlsx"
        puts "Convert #{opts[:f]} to TUBAME Knowledge XML."
        ToXml::Base.new(opts).process
        "XML"
      else
        puts opt.help if !opt.nil?
      end
    rescue
      warn "#{$!}\n#{$!.backtrace.join("\n")}" if ! opts[:f].nil?
      puts opt.help if opts[:f].nil?
      raise $!
    end
  end
end
