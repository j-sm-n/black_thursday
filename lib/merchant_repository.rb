class MerchantRepository
  attr_reader :count,
              :merchants

  def initialize
    @count = 0
    @merchants = []
  end

  def << (merchant)
    merchants << merchant
    @count = merchants.count
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
