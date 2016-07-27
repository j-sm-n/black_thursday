require "pry"
require "./lib/merchant_repository"

class Merchant
  attr_reader :id,
              :name,
              :parent,
              :repository

  def initialize(merchant_data, repository)
    @id          = merchant_data[:id]
    @name        = merchant_data[:name]
    @repository  = repository
    @created_at  = merchant_data[:created_at]
    @updated_at  = merchant_data[:updated_at]
  end

end
