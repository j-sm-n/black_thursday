require './lib/item'

class ItemRepository
  attr_reader :items,
              :contents

  def initialize(contents)
    @items = populate(contents)
  end

  def populate(contents)
    contents.map do |row|
      Item.new(row, self)
    end
  end

  def all
    items
  end

  def find_by_id(id)
    items.find { |item| item.id.to_i == id }
  end

  def find_by_name(name)
    items.find { |item| item.name.downcase == name.downcase }
  end

  def find_all_with_description(search_text)
    items.find_all { |item| item.description.downcase.include?(search_text.downcase) }
  end

  def find_all_by_price(price)
    items.find_all { |item| item.unit_price == BigDecimal.new(price)/100 }
  end

  def find_all_by_price_in_range(price_range_as_integers)
    items.find_all { |item| price_range_as_integers.include?(item.unit_price * 100) }
  end

  def find_all_by_merchant_id(id)
    items.find_all { |item| item.merchant_id.to_i == id }
  end

end
