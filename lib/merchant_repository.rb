require './lib/merchant'
require './lib/repository'

class MerchantRepository
  include Repository

  attr_reader :repository

  def initialize(contents, parent)
    @repository = populate(contents)
  end

  def populate(contents)
    contents.map do |row|
      Merchant.new(row, self)
    end
  end
  
  def find_all_by_name(name)
    merchants.find_all { |merchant| merchant.name.downcase.include?(name.downcase) }
  end

end
