require_relative "../lib/sales_engine"
require 'pry'

class SalesAnalyst
  attr_reader :item_repo,
              :merchant_repo

  def initialize(sales_engine)
    @item_repo = sales_engine.items
    @merchant_repo = sales_engine.merchants
  end
end
