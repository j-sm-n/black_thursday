class MerchantRepository
  attr_reader :merchants

  def initialize
    @merchants = []
  end

  def count
    merchants.count
  end

  def << (merchant)
    merchants << merchant
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
