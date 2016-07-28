require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/parser'

class SalesEngine
  attr_reader :items,
              :merchants

  def initialize(item_file, merchant_file)
    parser = Parser.new
    @items = ItemRepository.new(parser.load(item_file), self)
    @merchants = MerchantRepository.new(parser.load(merchant_file), self)
  end

  def self.from_csv(hash_of_file_paths)
    SalesEngine.new(hash_of_file_paths[:items], hash_of_file_paths[:merchants])
  end

  def find_merchant_by_merchant_id(id)
    @merchants.find_by_id(id)
  end
end
