require_relative '../lib/merchant'
require_relative '../lib/repository'

class MerchantRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize(contents, parent)
    @repository = contents.map { |row| Merchant.new(row, self) }
    @parent = parent
  end

  def find_all_by_name(name)
    repository.find_all do |merchant|
      merchant.case_insensitive_name.include?(name.downcase)
    end
  end

  def find_items_by_merchant(merchant_id)
    parent.find_items_by_merchant(merchant_id)
  end

  def find_invoices_by_merchant(id)
    parent.find_invoices_by_merchant(id)
  end

  def find_customers_of_merchant(id)
    parent.find_customers_of_merchant(id)
  end

  def inspect
    "#<#{self.class} #{@repository.size} rows>"
  end
end
