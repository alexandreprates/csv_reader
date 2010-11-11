require 'ostruct'

class CsvFileMissing < Exception; end
class NoMoreLines < Exception; end
class EmptyCsvFile < Exception; end


class CsvReader
  attr_reader :filename, :titles

  def initialize(filename)
    @filename = filename
    raise(CsvFileMissing, "file #{filename} not found", caller) unless has_file?
    raise(EmptyCsvFile, 'file is empty!', caller) if File.zero?(@filename)
    open_file
    read_titles
  end
  
  def read_one
    line = read_line
    line_to_os(line)
  end
 
  def read_all
    @file.inject([]) do |collection, line|
      collection << line_to_os(line)
    end
  end

  private 

  def open_file
    @file = File.open(filename, 'r')
  end

  def read_line
    raise(NoMoreLines, 'no more lines in file', caller) if @file.eof?
    @file.readline
  end

  def read_titles
    @titles = parse_line(read_line)
  end

  def has_file?
    File.exist? filename
  end
  
  def parse_line(line)
    line.chomp.split(';')
  end

  def line_to_hash(line)
    values = parse_line(line)
    fields_and_values = titles.zip(values).flatten
    Hash[*fields_and_values]
  end

  def line_to_os(line)
    fields = line_to_hash(line)
    OpenStruct.new(fields)
  end 

end
