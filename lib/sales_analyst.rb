require_relative "../lib/sales_engine"
require 'pry'

class SalesAnalyst
  attr_reader :merchants,
              :items,
              :item_count_per_merchant

  def initialize(sales_engine)
    @merchants = sales_engine.merchants.repository
    @item_count_per_merchant = find_how_many_items_merchants_sell # to collect number of items per merchant to calculate average
    @items = sales_engine.items.repository
  end

  def find_how_many_items_merchants_sell
    @merchants.map do |merchant|
      merchant.items.length
    end
  end

  def average_item_count_per_merchant #=> mean
    (item_count_per_merchant.reduce(:+)/item_count_per_merchant.count).to_f
  end

  def find_variance_of_items_sold
    item_count_per_merchant.map do |item_count|
      ((item_count - average_item_count_per_merchant) ** 2) / item_count_per_merchant.length
    end.reduce(:+)
  end

  def average_items_per_merchant_standard_deviation #=> st deviation
    Math.sqrt(find_variance_of_items_sold)
  end

  # def merchants_with_high_item_count
  #   # array of merchants who sell more than mean + standard deviation
  # end

end
