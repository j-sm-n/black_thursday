require "csv"

class Parser
  def load(file_name)
    CSV.open file_name, headers: true, header_converters: :symbol
  end
end
