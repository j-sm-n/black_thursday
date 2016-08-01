module DateAnalyst
  # DateAnalyst
  def days_of_the_week_invoices_were_made_on
    invoices.repository.map do |invoice|
      invoice.created_at.wday
    end
  end
  # DateAnalyst
  def invoice_count_per_day
     invoice_counts = Hash.new(0)
     days_of_the_week_invoices_were_made_on.each do |day|
       invoice_counts[day] += 1
     end
     invoice_counts
  end
  # DateAnalyst
  def average_invoices_per_day_created
    MathEngine.mean(invoice_count_per_day.values).to_f
  end
  # DateAnalyst
  def average_invoices_per_day_standard_deviation
    MathEngine.standard_deviation(invoice_count_per_day.values)
  end
  # DateAnalyst
  def top_days_more_than_one_std_deviation
    mean = average_invoices_per_day_created
    standard_deviation = average_invoices_per_day_standard_deviation

    invoice_count_per_day.select do |key, value|
      MathEngine.outlier?(value, mean, standard_deviation, 1)
    end
  end
  # DateAnalyst
  def top_days_by_invoice_count
    top_days_more_than_one_std_deviation.keys.map do |key|
      if key == 0
        "Sunday"
      elsif key == 1
        "Monday"
      elsif key == 2
        "Tuesday"
      elsif key == 3
        "Wednesday"
      elsif key == 4
        "Thursday"
      elsif key == 5
        "Friday"
      else
        "Saturday"
      end
    end
    # Refactored....
    # days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    # top_days_more_than_one_std_deviation.keys.map do { |key| days[key] }
  end

end
