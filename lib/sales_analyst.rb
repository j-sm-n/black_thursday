require_relative "../lib/sales_engine"
require_relative "../lib/math_engine"
require_relative "../lib/merchant_analyst"
require_relative "../lib/item_analyst"
require_relative "../lib/date_analyst"
require_relative "../lib/invoice_analyst"
require 'bigdecimal'

class SalesAnalyst
  include MerchantAnalyst
  include ItemAnalyst
  include DateAnalyst
  include InvoiceAnalyst

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
  # # InvoiceAnalyst
  # def number_of_invoices_per_status
  #   invoices.repository.map do |invoice|
  #     invoice.status
  #   end
  #   # Refactored...
  #   # invoices.repository.group_by { |invoice| invoice.status}
  #   # {:shipped => [invoice1, invoice2, invoice3]}
  # end
  # # InvoiceAnalyst
  # def invoice_status_counts
  #   status_counts = Hash.new(0)
  #   number_of_invoices_per_status.each do |status|
  #     status_counts[status] += 1
  #   end
  #   status_counts
  # end
  # # Refactored...
  # # number_of_invoices_per_status.each { |status| status.value.count }
  #
  # # InvoiceAnalyst
  # def total_invoices
  #   invoices.repository.count
  # end
  #
  # # InvoiceAnalyst
  # def invoice_status(status)
  #   number = invoice_status_counts[status]
  #   MathEngine.percentage(number, total_invoices)
  # end
  # # Refactored...
  # # MathEngine.percentage(invoice_status_counts[status], total_invoices)
end
