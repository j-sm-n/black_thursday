require "csv"

class Loader
  def self.load(file_name)
    CSV.open file_name, headers: true, header_converters: :symbol
  end
end
