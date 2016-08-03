require_relative '../lib/repository'
require_relative '../lib/invoice_item'

class InvoiceItemRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize
    @repository
    @parent
  end

  def from_csv(file_path, parent=nil)
    @repository = Loader.load(file_path).map do |row|
      InvoiceItem.new(row, self)
    end
    @parent = parent
  end

  def find_all_by_item_id(item_id)
    repository.find_all { |invoice_item| invoice_item.item_id == item_id }
  end

  def inspect
    "#<#{self.class} #{@repository.size} rows>"
  end

end
