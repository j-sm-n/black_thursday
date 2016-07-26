require "csv"
require "pry"

class Parser

  def initialize
  end

  def load(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol
  end

  def parse_merchant_csv(file_name)
    contents = load(file_name)
    contents.each do |row|
      id = row[:id]
      name = row[:name]
      
    end

  end
end
