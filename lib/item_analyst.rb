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

  def most_sold_item_for_merchant(merchant_id)
    merchant = merchants.find_by_id(merchant_id)
    highest_invoice_item = merchant.invoices.map do |invoice|
      invoice_items.find_highest_quantity_by_invoice(invoice.id)
    end.flatten

    grouped_invoice_items = highest_invoice_item.group_by do |invoice_item|
      invoice_item.quantity
    end

    grouped_invoice_items[grouped_invoice_items.keys.max].map do |invoice_item|
      items.find_by_id(invoice_item.item_id)
    end
  end


end
