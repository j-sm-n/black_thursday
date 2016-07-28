require_relative '../lib/item'
require_relative '../lib/repository'

class ItemRepository
  include Repository

  attr_reader :items,
              :contents,
              :parent,
              :repository

  def initialize(contents, parent)
    @repository = populate(contents)
    @parent = parent
  end

  def populate(contents)
    contents.map do |row|
      Item.new(row, self)
    end
  end

  def find_all_with_description(search_text)
    repository.find_all do |item|
      item.description.include?(search_text.downcase)
    end
  end

  def find_all_by_price(price)
    repository.find_all { |item| item.unit_price == BigDecimal.new(price) }
  end

  def find_all_by_price_in_range(price_range_as_integers)
    repository.find_all do |item|
      price_range_as_integers.include?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(id)
    repository.find_all { |item| item.merchant_id.to_i == id }
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def find_merchant_by_merchant_id(merchant_id)
    @parent.find_merchant_by_merchant_id(merchant_id)
  end
end
