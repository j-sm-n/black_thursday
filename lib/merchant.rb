require "pry"

class Merchant
  attr_reader :id,
              :name,
              :case_insensitive_name,
              :parent,
              :created_at,
              :updated_at

  def initialize(merchant_data, parent)
    @id                    = merchant_data[:id].to_i
    @name                  = merchant_data[:name]
    @case_insensitive_name = name.downcase
    @parent                = parent
    @created_at            = Date.parse(merchant_data[:created_at])
    @updated_at            = Date.parse(merchant_data[:updated_at])
  end

  def items
    parent.find_items_by_merchant(id)
  end

  def invoices
    parent.find_invoices_by_merchant(id)
  end

  def customers
    parent.find_customers_of_merchant(id)
  end

  def revenue
    invoices.map do |invoice|
      invoice.total
    end.reduce(:+)
  end

end
