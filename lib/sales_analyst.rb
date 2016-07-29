require_relative "../lib/sales_engine"
require 'pry'

class SalesAnalyst
  attr_reader :merchants,
              :items,
              :item_count_per_merchant,
              :item_count_average,
              :item_standard_deviation

  def initialize(sales_engine)
    @merchants = sales_engine.merchants.repository
    @item_count_per_merchant = find_how_many_items_merchants_sell
    @items = sales_engine.items.repository
    @item_count_average = average_item_count_per_merchant
    @item_standard_deviation = average_items_per_merchant_standard_deviation
  end

  def find_how_many_items_merchants_sell
    @merchants.map do |merchant|
      merchant.items.length
    end
  end

  def average_item_count_per_merchant #=> average
    (item_count_per_merchant.reduce(:+)/item_count_per_merchant.count).to_f
  end

  def find_variance_of_items_sold
    item_count_per_merchant.map do |item_count|
      ((item_count - average_item_count_per_merchant) ** 2) / item_count_per_merchant.length
    end.reduce(:+)
  end

  def average_items_per_merchant_standard_deviation
    Math.sqrt(find_variance_of_items_sold)
  end

  def merchants_with_high_item_count
    high_item_count_merchants = []
    item_count_per_merchant.each_with_index do |count, index|
      if count > (item_count_average + item_standard_deviation)
        high_item_count_merchants << merchants[index]
      end
    end
    high_item_count_merchants
  end
end
