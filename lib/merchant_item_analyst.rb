class MerchantItemAnalyst
  attr_reader :merchant_id,
              :analyst

  def initialize(merchant_id, analyst)
    @merchant_id = merchant_id
    @analyst = analyst
  end

  def merchant_paid_in_full_invoices
    analyst.merchants.find_by_id(merchant_id).invoices.find_all do |invoice|
      invoice.is_paid_in_full?
    end
  end

  def merchant_paid_in_full_invoice_items
    merchant_paid_in_full_invoices.map do |invoice|
      analyst.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
  end

  def group_invoice_items_by_quantity
    merchant_paid_in_full_invoice_items.group_by do |invoice_item|
      invoice_item.quantity
    end
  end

  def group_invoice_items_by_revenue
    merchant_paid_in_full_invoice_items.group_by do |invoice_item|
      invoice_item.price
    end
  end

  def max_quantity_invoice_items
    invoice_items = group_invoice_items_by_quantity
    invoice_items[invoice_items.keys.max]
  end

  def max_revenue_invoice_items
    invoice_items = group_invoice_items_by_revenue
    invoice_items[invoice_items.keys.max]
  end

  def most_sold_item_for_merchant
    max_quantity_invoice_items.map do |invoice_item|
      analyst.items.find_by_id(invoice_item.item_id)
    end
  end

  def best_item_for_merchant
    max_revenue_invoice_items.map do |invoice_item|
      analyst.items.find_by_id(invoice_item.item_id)
    end.first
  end

end
