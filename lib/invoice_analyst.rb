module InvoiceAnalyst

  def invoice_statuses
    invoices.repository.map { |invoice| invoice.status }
  end

  def group_statuses
    invoice_statuses.group_by do |status|
      status
    end
  end

  def invoice_status_counts
    grouping = group_statuses
    grouping.each_pair do |status, statuses|
        grouping[status] = statuses.length
    end
  end

  def total_invoices
    invoices.repository.count
  end

  def invoice_status(status)
    MathNerd.percentage(invoice_status_counts[status], total_invoices)
  end

end
