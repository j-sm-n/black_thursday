require_relative '../lib/loader'

module Repository
  def count
    repository.count
  end

  def all
    repository
  end

  def find_by_id(id)
    repository.find { |child| child.id == id }
  end

  def find_by_name(name)
    repository.find { |child| child.name.downcase == name.downcase }
  end

  def find_all_by_invoice_id(invoice_id)
    repository.find_all { |child| child.invoice_id == invoice_id }
  end
end
