require './lib/item'
require './lib/repository'

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
    repository.find_all { |item| item.description.downcase.include?(search_text.downcase) }
  end

  def find_all_by_price(price)
    repository.find_all { |item| item.unit_price == BigDecimal.new(price)/100 }
  end

  def find_all_by_price_in_range(price_range_as_integers)
    repository.find_all { |item| price_range_as_integers.include?(item.unit_price * 100) }
  end

  def find_all_by_merchant_id(id)
    repository.find_all { |item| item.merchant_id.to_i == id }
  end

end
