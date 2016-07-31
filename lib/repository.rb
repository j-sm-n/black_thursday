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

  def find_all_by_item_id(item_id)
    repository.find_all { |invoice_item| invoice_item.item_id == item_id }
  end
  
end
