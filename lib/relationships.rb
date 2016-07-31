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
end
