require_relative '../lib/invoice'
require_relative '../lib/repository'

class InvoiceRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize(contents, parent)
    @repository = contents.map { |row| Invoice.new(row, self) }
    @parent = parent
  end

  def find_all_by_customer_id(customer_id)
    repository.find_all { |invoice| invoice.customer_id == customer_id }
  end

  def find_all_by_merchant_id(merchant_id)
    repository.find_all { |invoice| invoice.merchant_id == merchant_id }
  end

  def find_all_by_status(status)
    repository.find_all { |invoice| invoice.status == status }
  end

  def find_all_by_created_at(date)
    repository.find_all { |invoice| invoice.created_at == Time.parse(date)}
  end

  def find_merchant_by_merchant_id(merchant_id)
    parent.find_merchant_by_merchant_id(merchant_id)
  end

  def find_items_on_invoice(invoice_id)
    parent.find_items_on_invoice(invoice_id)
  end

  def find_transactions_on_invoice(invoice_id)
    parent.find_transactions_on_invoice(invoice_id)
  end

  def find_customer_on_invoice(customer_id)
    parent.find_customer_on_invoice(customer_id)
  end

  def find_invoice_items_by_invoice(id)
    parent.find_invoice_items_by_invoice(id)
  end

  def inspect
    "#<#{self.class} #{@repository.size} rows>"
  end

end
