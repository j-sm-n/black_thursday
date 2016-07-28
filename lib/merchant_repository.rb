require_relative '../lib/merchant'
require_relative '../lib/repository'

class MerchantRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize(contents, parent)
    @repository = populate(contents)
    @parent = parent
  end

  def populate(contents)
    contents.map do |row|
      Merchant.new(row, self)
    end
  end

  def find_all_by_name(name)
    repository.find_all { |merchant| merchant.name.downcase.include?(name.downcase) }
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def find_items_by_merchant(merchant_id)
    parent.find_items_by_merchant(merchant_id)
  end


end
