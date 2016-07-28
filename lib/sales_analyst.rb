require_relative "../lib/sales_engine"
require 'pry'

class SalesAnalyst
  attr_reader :item_repo,
              :merchant_repo,
              :merchant_array,
              :item_array

  attr_accessor :items_per_merchant

  def initialize(sales_engine)
    @merchant_repo = sales_engine.merchants # returns instance of MR
    @items_per_merchant = [] # to collect number of items per merchant to calculate average
    @merchants = merchant_repo.repository
    @item_repo = sales_engine.items
    @items = item_repo.repository
  end

  def find_how_many_items_merchants_sell
    @items_per_merchant = @merchants.map do |merchant|
      merchant_items = merchant.items.length
    end
  end

  def average_items_per_merchant
    items_count = find_how_many_items_merchants_sell.count
    items_sum = find_how_many_items_merchants_sell.reduce(:+)
    average = (items_sum/items_count).to_f
  end

  def find_variance_of_items_sold
    @items_per_merchant.map do |items|
      (((items - average_items_per_merchant) ** 2) / @items_per_merchant.length)
    end.reduce(:+)
  end

  def average_items_per_merchant_standard_deviation
    Math.sqrt(find_variance_of_items_sold)
  end

end
