require './lib/merchant'

class MerchantRepository
  attr_reader :merchants,
              :contents

  def initialize(contents)
    @merchants = []
    @contents = contents
  end

  def populate(contents)
    contents.each do |row|
     this_merchant = Merchant.new(parse_row(row))
     this_merchant.set_parent(self)
     merchants << this_merchant
    end
  end

  def parse_row(row)
    {:id => row[:id],
     :name => row[:name],
     :created_at => row[:created_at],
     :updated_at => row[:updated_at]}
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
    merchants.find { |merchant| merchant.id.to_i == id }
  end

  def find_by_name(name)
    merchants.find { |merchant| merchant.name.downcase == name.downcase }
  end

  def find_all_by_name(name)
    merchants.find_all { |merchant| merchant.name.downcase.include?(name.downcase) }
  end

end
