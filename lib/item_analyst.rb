module ItemAnalyst
  # ItemsAnalyst
  def golden_items
    mean = MathEngine.mean(items.repository.map { |item| item.unit_price })
    unit_price_total = items.repository.map { |item| item.unit_price }
    standard_deviation = MathEngine.standard_deviation(unit_price_total)
    items.repository.find_all do |item|
      MathEngine.outlier?(item.unit_price, mean, standard_deviation, 2)
    end
  end
end
