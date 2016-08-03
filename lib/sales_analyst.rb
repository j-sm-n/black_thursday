require_relative "../lib/sales_engine"
require_relative "../lib/math_nerd"
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

  def invoice_items
    sales_engine.invoice_items
  end

  def transactions
    sales_engine.transactions
  end

  def customers
    sales_engine.customers
  end
end
