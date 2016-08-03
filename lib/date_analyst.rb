module DateAnalyst

  def invoice_count_per_day
    days = invoices.repository.map { |invoice| invoice.created_at.wday }
    grouped_days = days.group_by { |day| day }
    grouped_days.each { |key, value| grouped_days[key] = value.length}
  end

  def average_invoices_per_day_created
    MathNerd.mean(invoice_count_per_day.values).to_f
  end

  def average_invoices_per_day_standard_deviation
    MathNerd.standard_deviation(invoice_count_per_day.values)
  end

  def top_days_more_than_one_std_deviation
    invoice_count_per_day.select do |key, value|
      mean = average_invoices_per_day_created
      std_dev = average_invoices_per_day_standard_deviation
      MathNerd.outlier?(value, mean, std_dev, 1)
    end
  end

  def top_days_by_invoice_count
    top_days_more_than_one_std_deviation.keys.map do |key|
      ["Sunday","Monday","Tuesday",
       "Wednesday","Thursday","Friday","Saturday"][key]
    end
  end

  def total_revenue_by_date(date)
    invoices.find_all_by_created_at(date).map do |invoice|
      revenue_on_invoice(invoice.id)
    end.reduce(:+)
  end

  def revenue_on_invoice(invoice_id)
    invoice_items.find_all_by_invoice_id(invoice_id).map do |invoice_item|
      invoice_item.price
    end.reduce(:+)
  end

end
