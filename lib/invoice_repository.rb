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
    repository.find_all { |invoice| invoice.status.to_s == status }
  end

end
