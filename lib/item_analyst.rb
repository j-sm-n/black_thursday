require_relative '../lib/merchant_item_analyst'

module ItemAnalyst

  def golden_items
    mean = MathNerd.mean(items.repository.map { |item| item.unit_price })
    unit_price_total = items.repository.map { |item| item.unit_price }
    standard_deviation = MathNerd.standard_deviation(unit_price_total)
    items.repository.find_all do |item|
      MathNerd.outlier?(item.unit_price, mean, standard_deviation, 2)
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    merchant_item_analyst = MerchantItemAnalyst.new(merchant_id, self)
    merchant_item_analyst.most_sold_item_for_merchant
  end

  def best_item_for_merchant(merchant_id)
    merchant_item_analyst = MerchantItemAnalyst.new(merchant_id, self)
    merchant_item_analyst.best_item_for_merchant
  end

end
