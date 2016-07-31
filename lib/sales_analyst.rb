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
      MathEngine.outlier?(merchant.invoices.count, mean, standard_deviation, 2)
    end
  end

  def bottom_merchants_by_invoice_count
    mean = MathEngine.mean(invoice_counts_for_all_merchants)
    standard_deviation = MathEngine.standard_deviation(invoice_counts_for_all_merchants)
    merchants.all.find_all do |merchant|
      MathEngine.outlier?(merchant.invoices.count, mean, standard_deviation, -2)
    end
  end

  def days_of_the_week_invoices_were_made_on
    invoices.repository.map do |invoice|
      invoice.created_at.wday
    end
  end

  def invoice_count_per_day
     invoice_counts = Hash.new(0)
     days_of_the_week_invoices_were_made_on.each do |day|
       invoice_counts[day] += 1
     end
     invoice_counts
  end

  def average_invoices_per_day_created
    MathEngine.mean(invoice_count_per_day.values).to_f
  end

  def average_invoices_per_day_standard_deviation
    MathEngine.standard_deviation(invoice_count_per_day.values)
  end

  def top_days_more_than_one_std_deviation
    mean = average_invoices_per_day_created
    standard_deviation = average_invoices_per_day_standard_deviation

    invoice_count_per_day.select do |key, value|
      MathEngine.outlier?(value, mean, standard_deviation, 1)
    end
  end

  def top_days_by_invoice_count
    top_days_more_than_one_std_deviation.keys.map do |key|
      if key == 0
        "Sunday"
      elsif key == 1
        "Monday"
      elsif key == 2
        "Tuesday"
      elsif key == 3
        "Wednesday"
      elsif key == 4
        "Thursday"
      elsif key == 5
        "Friday"
      else
        "Saturday"
      end
    end
  end

  def number_of_invoices_per_status
    invoices.repository.map do |invoice|
      invoice.status
    end
  end

  def invoice_status_counts
    status_counts = Hash.new(0)
    number_of_invoices_per_status.each do |status|
      status_counts[status] += 1
    end
    status_counts
  end

  def total_invoices
    invoices.repository.count
  end

  def invoice_status(status)
    number = invoice_status_counts[status] 
    MathEngine.percentage(number, total_invoices)
  end
end
