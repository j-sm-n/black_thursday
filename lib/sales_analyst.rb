require_relative "../lib/sales_engine"
require_relative "../lib/math_engine"
require 'bigdecimal'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def items
    sales_engine.items
  end

  def merchants
    sales_engine.merchants
  end

  def invoices
    sales_engine.invoices
  end

  def item_counts_for_all_merchants
    merchants.repository.map { |merchant| merchant.items.length }
  end

  def average_items_per_merchant
    MathEngine.mean(item_counts_for_all_merchants).to_f
  end

  def average_items_per_merchant_standard_deviation
    MathEngine.standard_deviation(item_counts_for_all_merchants)
  end

  def merchants_with_high_item_count
    mean = MathEngine.mean(item_counts_for_all_merchants)
    standard_deviation = MathEngine.standard_deviation(item_counts_for_all_merchants)
    merchants.all.find_all do |merchant|
      MathEngine.outlier?(merchant.items.count, mean, standard_deviation, 1)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    this_merchants_items = items.find_all_by_merchant_id(merchant_id)
    prices_of_this_merchants_items = this_merchants_items.map do |item|
      item.unit_price_to_dollars
    end
    BigDecimal.new(MathEngine.mean(prices_of_this_merchants_items),4) unless prices_of_this_merchants_items.empty?
  end

  def average_average_price_per_merchant
    MathEngine.mean(merchants.repository.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end)
  end

  def golden_items
    mean = MathEngine.mean(items.repository.map { |item| item.unit_price })
    standard_deviation = MathEngine.standard_deviation(items.repository.map { |item| item.unit_price })
    items.repository.find_all do |item|
      MathEngine.outlier?(item.unit_price, mean, standard_deviation, 2)
    end
  end

  def invoice_counts_for_all_merchants
    merchants.repository.map { |merchant| merchant.invoices.length }
  end

  def average_invoices_per_merchant
    MathEngine.mean(invoice_counts_for_all_merchants).to_f
  end

  def average_invoices_per_merchant_standard_deviation
    MathEngine.standard_deviation(invoice_counts_for_all_merchants)
  end

  def top_merchants_by_invoice_count
    mean = MathEngine.mean(invoice_counts_for_all_merchants)
    standard_deviation = MathEngine.standard_deviation(invoice_counts_for_all_merchants)
    merchants.all.find_all do |merchant|
      MathEngine.outlier?(merchant.invoices.count, mean, standard_deviation, 1)
    end
  end

end
