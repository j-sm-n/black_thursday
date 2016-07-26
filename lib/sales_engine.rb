require './lib/item_repository'
require './lib/merchant_repository'
require './lib/parser'

class SalesEngine
  attr_reader :items,
              :merchants

  def initialize(item_file, merchant_file)
    parser = Parser.new
    @items = ItemRepository.new(parser.load(item_file))
    @merchants = MerchantRepository.new(parser.load(merchant_file))
  end

  def self.from_csv(hash_of_file_paths)
    SalesEngine.new(hash_of_file_paths[:items], hash_of_file_paths[:merchants])
  end
end
