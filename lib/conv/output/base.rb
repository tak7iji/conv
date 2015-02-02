# encoding: utf-8

require 'fileutils'

module Conv::Output
  class Base
    def initialize argv
      FileUtils.mkdir argv[:o] if ! argv[:o].nil? && ! File.exists?(argv[:o])
    end
    
    def get_output
      yield @out
      @out.close
    end
  
    def << row
      @sheet.add_row row
    end
  
    def close
      FileUtils::mv @doc.path, "#{@output_file}"
      @doc.cleanup
    end
  end
end
