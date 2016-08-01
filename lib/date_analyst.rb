module DateAnalyst

  def invoice_count_per_day
    days = invoices.repository.map { |invoice| invoice.created_at.wday }
    grouped_days = days.group_by { |day| day }
    grouped_days.each { |key, value| grouped_days[key] = value.length}
  end

  def average_invoices_per_day_created
    MathEngine.mean(invoice_count_per_day.values).to_f
  end

  def average_invoices_per_day_standard_deviation
    MathEngine.standard_deviation(invoice_count_per_day.values)
  end

  def top_days_more_than_one_std_deviation
    invoice_count_per_day.select do |key, value|
      MathEngine.outlier?(value, average_invoices_per_day_created,
                          average_invoices_per_day_standard_deviation, 1)
    end
  end

  def top_days_by_invoice_count
    top_days_more_than_one_std_deviation.keys.map do |key|
      ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][key]
    end
  end

  def total_revenu_by_date(date)

  end

end
