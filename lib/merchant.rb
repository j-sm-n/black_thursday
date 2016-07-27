require "pry"
require "./lib/merchant_repository"

class Merchant
  attr_reader :id,
              :name,
              :parent,
              :created_at,
              :updated_at

  def initialize(merchant_data, parent)
    @id          = merchant_data[:id].to_i
    @name        = merchant_data[:name]
    @parent      = parent
    @created_at  = Date.parse(merchant_data[:created_at])
    @updated_at  = Date.parse(merchant_data[:updated_at])
  end

end
