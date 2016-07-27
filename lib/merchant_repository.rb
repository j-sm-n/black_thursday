require './lib/merchant'
require './lib/repository'

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

end
