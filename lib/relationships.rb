module Relationships
  def find_merchant_by_merchant_id(id)
    merchants.find_by_id(id)
  end

  def find_items_by_merchant(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_by_merchant(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end

  def find_items_on_invoice(invoice_id)
    invoice_items.find_all_by_invoice_id(invoice_id).map do |invoice_item|
        items.find_by_id(invoice_item.item_id)
    end
  end

  def find_transactions_on_invoice(invoice_id)
    transactions.find_all_by_invoice_id(invoice_id)
  end

  def find_customer_on_invoice(customer_id)
    customers.find_by_id(customer_id)
  end

end
