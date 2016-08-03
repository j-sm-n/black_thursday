module MerchantAnalyst
  def item_counts_for_all_merchants
    merchants.repository.map { |merchant| merchant.items.length }
  end

  def average_items_per_merchant
    MathNerd.mean(item_counts_for_all_merchants).to_f
  end

  def average_items_per_merchant_standard_deviation
    MathNerd.standard_deviation(item_counts_for_all_merchants)
  end

  def merchants_with_high_item_count
    mean = MathNerd.mean(item_counts_for_all_merchants)
    standard_dev = MathNerd.standard_deviation(item_counts_for_all_merchants)
    merchants.all.find_all do |merchant|
      MathNerd.outlier?(merchant.items.count, mean, standard_dev, 1)
    end
  end

  def average_item_price_for_merchant(merchant_id)
    this_merchants_items = items.find_all_by_merchant_id(merchant_id)
    prices_of_this_merchants_items = this_merchants_items.map do |item|
      item.unit_price_to_dollars
    end
    unless prices_of_this_merchants_items.empty?
      BigDecimal.new(MathNerd.mean(prices_of_this_merchants_items),4)
    end
  end

  def average_average_price_per_merchant
    MathNerd.mean(merchants.repository.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end)
  end


  def invoice_counts_for_all_merchants
    merchants.repository.map { |merchant| merchant.invoices.length }
  end

  def average_invoices_per_merchant
    MathNerd.mean(invoice_counts_for_all_merchants).to_f
  end

  def average_invoices_per_merchant_standard_deviation
    MathNerd.standard_deviation(invoice_counts_for_all_merchants)
  end

  def top_merchants_by_invoice_count
    mean = MathNerd.mean(invoice_counts_for_all_merchants)
    standard_dev = MathNerd.standard_deviation(invoice_counts_for_all_merchants)
    merchants.all.find_all do |merchant|
      MathNerd.outlier?(merchant.invoices.count, mean, standard_dev, 2)
    end
  end

  def bottom_merchants_by_invoice_count
    mean = MathNerd.mean(invoice_counts_for_all_merchants)
    standard_dev = MathNerd.standard_deviation(invoice_counts_for_all_merchants)
    merchants.all.find_all do |merchant|
      MathNerd.outlier?(merchant.invoices.count, mean, standard_dev, -2)
    end
  end

  def revenue_by_merchant(merchant_id)
    merchants.find_by_id(merchant_id).revenue
  end

  def find_all_merchant_revenues
    merchants.all.map do |merchant|
      [merchant, revenue_by_merchant(merchant.id)]
    end
  end

  def top_revenue_earners(number = 20)
    merchants_ranked_by_revenue[0...number]
  end

  def merchants_ranked_by_revenue
    ranked_merchants = find_all_merchant_revenues.sort_by do |merchant_revenue|
      merchant_revenue[1]
    end.reverse

    ranked_merchants.map do |merchant_revenue|
      merchant_revenue[0]
    end
  end

  def merchants_with_pending_invoices
    the_merchants = merchants.all.find_all do |merchant|
      merchant.has_pending_invoices?
    end
  end

  def merchants_with_only_one_item
    merchants.all.find_all do |merchant|
      merchant.has_only_one_item?
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      month_number_to_name(merchant.created_at.month) == month
    end
  end

  def month_number_to_name(month_num)
    ["January", "February", "March", "April", "May", "June",
     "July", "August", "September", "October", "November",
     "December"][month_num - 1]
  end

end
