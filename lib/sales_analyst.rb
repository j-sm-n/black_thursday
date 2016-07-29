require_relative "../lib/sales_engine"
require 'pry'
require 'bigdecimal'

class SalesAnalyst
  attr_reader :merchants,
              :items,
              :item_count_per_merchant,
              :sales_engine,
              :item_count_average,
              :item_standard_deviation

  def initialize(sales_engine)
    @merchants = sales_engine.merchants.repository
    @item_count_per_merchant = find_how_many_items_merchants_sell
    @items = sales_engine.items.repository
    @sales_engine = sales_engine
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

  require_relative "../lib/math_engine"
  def average_item_price_for_merchant(merchant_id)
    this_merchants_items = sales_engine.items.find_all_by_merchant_id(merchant_id)
    prices_of_this_merchants_items = this_merchants_items.map do |item|
      item.unit_price_to_dollars
    end
    BigDecimal(MathEngine.mean(prices_of_this_merchants_items),2) unless prices_of_this_merchants_items.empty?
  end

  def average_average_price_per_merchant
    MathEngine.mean(merchants.map { |merchant| average_item_price_for_merchant(merchant.id) })
  end

  def golden_items
    all_the_items = sales_engine.items.all
    average_item_price = MathEngine.mean(all_the_items.map { |item| item.unit_price })
    standard_deviation = MathEngine.standard_deviation(all_the_items.map { |item| item.unit_price })
    golend_items = all_the_items.find_all { |item| item.unit_price >= average_item_price + standard_deviation + standard_deviation}
  end

#   Which are our Golden Items?
#
# Given that our platform is going to charge merchants based on their sales, expensive items are extra exciting to us. Which are our "Golden Items", those two standard-deviations above the average item price? Return the item objects of these "Golden Items".
#
# sa.golden_items # => [<item>, <item>, <item>, <item>]

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
