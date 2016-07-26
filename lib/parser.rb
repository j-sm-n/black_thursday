require "csv"
require "./lib/item"
require "./lib/item_repository"
require "pry"

class Parser
  def load(file_name)
    CSV.open file_name, headers: true, header_converters: :symbol
  end

  def parse_items_csv(file_name)
    item_repository = ItemRepository.new
    contents = load(file_name)
    contents.each do |row|
      item_repository << Item.new({:id => row[:id],
                                  :name => row[:name],
                                  :description => row[:description],
                                  :description => row[:description],
                                  :unit_price => row[:unit_price],
                                  :created_at => row[:created_at],
                                  :updated_at => row[:updated_at],
                                  :merchant_id => row[:merchant_id]})
    end
    return item_repository
  end
end
