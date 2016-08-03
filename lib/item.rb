require 'bigdecimal'

class Item
  attr_reader :id,
              :name,
              :description,
              :case_insensitive_description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id,
              :parent,
              :unit_price_to_dollars

  def initialize(data, parent)
    @id                           = data[:id].to_i
    @name                         = data[:name]
    @description                  = data[:description]
    @case_insensitive_description = description.downcase
    @unit_price                   = BigDecimal.new(data[:unit_price])/100
    @created_at                   = Time.parse(data[:created_at])
    @updated_at                   = Time.parse(data[:updated_at])
    @merchant_id                  = data[:merchant_id].to_i
    @parent                       = parent
    @unit_price_to_dollars        = unit_price.to_f
  end

  def merchant
    parent.find_merchant_by_merchant_id(self.merchant_id)
  end
end
