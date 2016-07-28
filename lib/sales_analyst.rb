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
    @merchant_array = merchant_repo.repository
    @item_repo = sales_engine.items
    @item_array = item_repo.repository
  end

  def find_how_many_items_merchants_sell
    @items_per_merchant = @merchant_array.map do |merchant|
      merchant_item_array = merchant.items
      merchant_item_array.length
    end
  end
end
