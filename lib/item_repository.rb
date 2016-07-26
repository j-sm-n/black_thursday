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

end
