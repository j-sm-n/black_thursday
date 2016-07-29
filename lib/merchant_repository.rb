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
    repository.find_all { |merchant| merchant.case_insensitive_name.include?(name.downcase) }
  end

  def find_items_by_merchant(merchant_id)
    parent.find_items_by_merchant(merchant_id)
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
