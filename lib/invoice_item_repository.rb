require_relative '../lib/loader'
require_relative '../lib/repository'
require_relative '../lib/invoice_item'

class InvoiceItemRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize(instantiation_hash=nil)
    @repository = instantiation_hash[:contents].map do |row|
      InvoiceItem.new(row, self)
    end
    @parent = instantiation_hash[:parent]
  end

  def self.from_csv(file_path, parent=nil)
    contents = Loader.load(file_path)
    InvoiceItemRepository.new({contents:contents,parent:parent})
  end
end
