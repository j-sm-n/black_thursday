require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/customer_repository'
require_relative '../lib/relationships'
require_relative '../lib/loader'

class SalesEngine
  include Relationships

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def self.from_csv(path)
    SalesEngine.new(path)
  end

  def items
    @items ||= ItemRepository.new(Loader.load(path[:items]), self)
  end

  def merchants
    @merchants ||= MerchantRepository.new(Loader.load(path[:merchants]), self)
  end

  def invoices
    @invoices ||= InvoiceRepository.new(Loader.load(path[:invoices]), self)
  end

  def invoice_items
    @invoice_items ||= create(path[:invoice_items], InvoiceItemRepository.new)
  end

  def transactions
    @transactions ||= create(path[:transactions], TransactionRepository.new)
  end

  def customers
    @customers ||= create(path[:customers], CustomerRepository.new)
  end

  def create(file_path, repository)
    repository.from_csv(file_path, self)
    return repository
  end

end
