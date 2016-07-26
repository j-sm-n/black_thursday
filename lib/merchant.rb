require "pry"
require "./lib/merchant_repository"

class Merchant
  attr_reader :id,
              :name,
              :parent

  def initialize(merchant)
    @id = merchant[:id]
    @name = merchant[:name]
    @parent = nil
  end

  def set_parent(merchant_repository)
    @parent = merchant_repository
  end
end
