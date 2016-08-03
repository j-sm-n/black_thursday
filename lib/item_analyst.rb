module ItemAnalyst
  # ItemsAnalyst
  def golden_items
    mean = MathEngine.mean(items.repository.map { |item| item.unit_price })
    unit_price_total = items.repository.map { |item| item.unit_price }
    standard_deviation = MathEngine.standard_deviation(unit_price_total)
    items.repository.find_all do |item|
      MathEngine.outlier?(item.unit_price, mean, standard_deviation, 2)
    end
  end

  def merchant_paid_in_full_invoices(merchant_id)
    merchants.find_by_id(merchant_id).invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end
  end

  def merchant_paid_in_full_invoice_items(merchant_id)
    merchant_paid_in_full_invoices(merchant_id).map do |invoice|
      invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
  end

  def group_invoice_items_by_quantity(merchant_id)
    merchant_paid_in_full_invoice_items(merchant_id).group_by do |invoice_item|
      invoice_item.quantity
    end
  end

  def group_invoice_items_by_revenue(merchant_id)
    merchant_paid_in_full_invoice_items(merchant_id).group_by do |invoice_item|
      invoice_item.price
    end
  end

  def max_quantity_invoice_items(merchant_id)
    invoice_items = group_invoice_items_by_quantity(merchant_id)
    invoice_items[invoice_items.keys.max]
  end

  def max_revenue_invoice_items(merchant_id)
    invoice_items = group_invoice_items_by_revenue(merchant_id)
    invoice_items[invoice_items.keys.max]
  end

  def most_sold_item_for_merchant(merchant_id)
    max_quantity_invoice_items(merchant_id).map do |invoice_item|
      items.find_by_id(invoice_item.item_id)
    end
  end

  def best_item_for_merchant(merchant_id)
    max_revenue_invoice_items(merchant_id).map do |invoice_item|
      items.find_by_id(invoice_item.item_id)
    end.first
  end

end
