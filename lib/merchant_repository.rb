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
    merchants.find { |merchant| merchant.name == name }
  end

end
# find_by_name - returns either nil or an instance of Merchant having done a case insensitive search
# find_all_by_name - returns either [] or one or more matches which contain the supplied name fragment, case insensitive
