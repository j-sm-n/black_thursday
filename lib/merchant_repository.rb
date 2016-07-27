require './lib/merchant'

class MerchantRepository
  attr_reader :merchants

  def initialize(contents, parent)
    @merchants = populate(contents)
  end

  def populate(contents)
    contents.map do |row|
      Merchant.new(row, self)
    end
  end

  def count
    merchants.count
  end

  def all
    merchants
  end

  def find_by_id(id)
    merchants.find { |merchant| merchant.id == id }
  end

  def find_by_name(name)
    merchants.find { |merchant| merchant.name.downcase == name.downcase }
  end

  def find_all_by_name(name)
    merchants.find_all { |merchant| merchant.name.downcase.include?(name.downcase) }
  end

end
