require 'bigdecimal'

class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id

  def initialize(id, name, description, unit_price, created_at, updated_at, merchant_id)
    @id = id
    @name = name
    @description = description
    @unit_price = unit_price
    @created_at = created_at
    @updated_at = updated_at
    @merchant_id = merchant_id
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

end
  # attr_reader :id,
  #             :name
  #
  # def initialize(id, name)
  #   @id = id
  #   @name = name
  # end



# The Item instance offers the following methods:
#
# id - returns the integer id of the item
# name - returns the name of the item
# description - returns the description of the item
# unit_price - returns the price of the item formatted as a BigDecimal
# created_at - returns a Time instance for the date the item was first created
# updated_at - returns a Time instance for the date the item was last modified
# merchant_id - returns the integer merchant id of the item
# It also offers the following method:
#
# unit_price_to_dollars - returns the price of the item in dollars formatted as a Float
# We create an instance like this:
#
# i = Item.new({
#   :name        => "Pencil",
#   :description => "You can use it to write things",
#   :unit_price  => BigDecimal.new(10.99,4),
#   :created_at  => Time.now,
#   :updated_at  => Time.now,
# })
