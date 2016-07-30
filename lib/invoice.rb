require_relative '../lib/invoice_repository'

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
    @created_at  = Date.parse(invoice_data[:created_at])
    @updated_at  = Date.parse(invoice_data[:updated_at])
    @parent      = parent
  end

  def merchant
    @parent.find_merchant_by_merchant_id(self.merchant_id)
  end
end
