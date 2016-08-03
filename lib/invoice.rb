class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :parent

  def initialize(invoice_data, parent)
    @id          = invoice_data[:id].to_i
    @customer_id = invoice_data[:customer_id].to_i
    @merchant_id = invoice_data[:merchant_id].to_i
    @status      = invoice_data[:status].to_sym
    @created_at  = Time.parse(invoice_data[:created_at])
    @updated_at  = Time.parse(invoice_data[:updated_at])
    @parent      = parent
  end

  def merchant
    parent.find_merchant_by_merchant_id(merchant_id)
  end

  def items
    parent.find_items_on_invoice(id)
  end

  def transactions
    parent.find_transactions_on_invoice(id)
  end

  def customer
    parent.find_customer_on_invoice(customer_id)
  end

  def is_paid_in_full?
    has_transactions? && transactions.any? do |transaction|
      transaction.result == "success"
    end
  end

  def invoice_item
    parent.find_invoice_items_by_invoice(id)
  end

  def total
    invoice_item.reduce(0) do |total, invoice_item|
      total += is_paid_in_full? ? invoice_item.price : 0
    end
  end

  private

  def has_transactions?
    !transactions.empty?
  end

end
