require "csv"
require "./lib/merchant"
require "./lib/merchant_repository"
require "pry"

class Parser

  def initialize
  end

  def load(file_name)
    contents = CSV.open file_name, headers: true, header_converters: :symbol
  end

  def parse_merchant_csv(file_name)
    merchant_repository = MerchantRepository.new
    contents = load(file_name)
    contents.each do |row|
      merchant_repository << Merchant.new({:id => row[:id], :name => row[:name]})
    end
    return merchant_repository
  end
end
# se = SalesEngine.from_csv({
#   :items     => "./data/items.csv",
#   :merchants => "./data/merchants.csv",
# })
#
# class SalesEngine
#   def initialize(csv_list)
#     items_file = csv_list[:items]
#     @merchant_repo = parse_merchant_csv(file_name)
#     @items_repo = parse_items_csv(file_name)
#   end
#
#
# end
