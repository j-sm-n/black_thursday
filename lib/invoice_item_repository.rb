require_relative '../lib/loader'
require_relative '../lib/repository'
require_relative '../lib/invoice_item'
require 'pry'

class InvoiceItemRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize
    @repository
    @parent
  end

  def from_csv(file_path, parent=nil)
    @repository = Loader.load(file_path).map { |row| InvoiceItem.new(row, self) }
    @parent = parent
  end

  def find_all_by_item_id(item_id)
    repository.find_all { |invoice_item| invoice_item.item_id == item_id }
  end

  def inspect
    "#<#{self.class} #{@repository.size} rows>"
  end

  def find_highest_quantity_by_invoice(invoice_id)
    grouped_invoice_items = find_all_by_invoice_id(invoice_id).group_by do |invoice_item|
      invoice_item.quantity
    end
    grouped_invoice_items[grouped_invoice_items.keys.max]
  end
end
