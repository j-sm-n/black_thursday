require "pry"

class ItemRepository
  attr_reader :count,
              :items

  def initialize
    @count = 0
    @items = []
  end

  def << (item)
    items << item
    @count = items.count
  end

  def all
    items
  end

  def find_by_id(id)
    items.find { |item| item.id == id }
  end

  def find_by_name(name)
    items.find { |item| item.name.downcase == name.downcase }
  end

  def find_all_with_description(search_text)
    items.find_all { |item| item.description.downcase.include?(search_text.downcase) }
  end

  def find_all_by_price(price)
    items.find_all { |item| BigDecimal.new(item.unit_price,4) == price }
  end

  def find_all_by_price_in_range(price_range)
  end

end
