require 'bigdecimal'
require './lib/item_repository'

class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id,
              :parent

  def initialize(item)
    @id          = item[:id]
    @name        = item[:name]
    @description = item[:description]
    @unit_price  = item[:unit_price]
    @created_at  = item[:created_at]
    @updated_at  = item[:updated_at]
    @merchant_id = item[:merchant_id]
    @parent      = nil
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def set_parent(item_repository)
    @parent = item_repository
  end

end
