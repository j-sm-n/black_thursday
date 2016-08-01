module InvoiceAnalyst
  # InvoiceAnalyst
  def number_of_invoices_per_status
    invoices.repository.map do |invoice|
      invoice.status
    end
    # Refactored...
    # invoices.repository.group_by { |invoice| invoice.status}
    # {:shipped => [invoice1, invoice2, invoice3]}
  end
  # InvoiceAnalyst
  def invoice_status_counts
    status_counts = Hash.new(0)
    number_of_invoices_per_status.each do |status|
      status_counts[status] += 1
    end
    status_counts
  end
  # Refactored...
  # number_of_invoices_per_status.each { |status| status.value.count }

  # InvoiceAnalyst
  def total_invoices
    invoices.repository.count
  end

  # InvoiceAnalyst
  def invoice_status(status)
    number = invoice_status_counts[status]
    MathEngine.percentage(number, total_invoices)
  end
  # Refactored...
  # MathEngine.percentage(invoice_status_counts[status], total_invoices)

end
