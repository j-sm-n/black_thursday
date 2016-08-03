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

  def merchant_invoices_that_are_not_returned(merchant_id)
    merchants.find_by_id(merchant_id).invoices.find_all do |invoice|
      invoice.shipped? || invoice.pending? #Maybe should just be shipped?
    end
  end

  def invoice_items_of_invoice_quantities(invoice_id)
    invoice_items.find_all_by_invoice_id(invoice_id).group_by do |invoice_item|
      invoice_item.quantity
    end
  end

  def highest_quantity_invoice_items_by_invoice(invoice_id)
    grouped_invoice_items = invoice_items_of_invoice_quantities(invoice_id)
    just_invoice_items = grouped_invoice_items[grouped_invoice_items.keys.max]
    why_do_I_take_one_invoice_item = [just_invoice_items[0]]
  end

  def get_all_highest_quantity_invoice_items_of_merchant(merchant_id)
    merchant_invoices_that_are_not_returned(merchant_id).map do |invoice|
      highest_quantity_invoice_items_by_invoice(invoice.id)
    end.flatten
  end

  def group_highest_quantity_invoice_items_by_quantity(merchant_id)
    get_all_highest_quantity_invoice_items_of_merchant(merchant_id).group_by do |invoice_item|
      invoice_item.quantity
    end
  end

  def highest_quantity_invoice_items(merchant_id)
    grouped_invoice_items = group_highest_quantity_invoice_items_by_quantity(merchant_id)
    grouped_invoice_items[grouped_invoice_items.keys.max]
  end

  def most_sold_item_for_merchant(merchant_id)
    highest_quantity_invoice_items(merchant_id).map do |invoice_item|
      items.find_by_id(invoice_item.item_id)
    end
  end

end
