module DateAnalyst

  def days_of_the_week_invoices_were_made_on
    invoices.repository.map do |invoice|
      invoice.created_at.wday
    end
  end

  def invoice_count_per_day
     invoice_counts = Hash.new(0)
     days_of_the_week_invoices_were_made_on.each do |day|
       invoice_counts[day] += 1
     end
     invoice_counts
  end

  def average_invoices_per_day_created
    MathEngine.mean(invoice_count_per_day.values).to_f
  end

  def average_invoices_per_day_standard_deviation
    MathEngine.standard_deviation(invoice_count_per_day.values)
  end

  def top_days_more_than_one_std_deviation
    mean = average_invoices_per_day_created
    standard_deviation = average_invoices_per_day_standard_deviation

    invoice_count_per_day.select do |key, value|
      MathEngine.outlier?(value, mean, standard_deviation, 1)
    end
  end

  def top_days_by_invoice_count
    days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    top_days_more_than_one_std_deviation.keys.map { |key| days[key] }
  end

  

end
