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

  attr_reader :file_paths

  def initialize(file_paths)
    @file_paths = file_paths
  end

  def self.from_csv(file_paths)
    SalesEngine.new(file_paths)
  end

  def items
    @items ||= ItemRepository.new(Loader.load(file_paths[:items]), self)
  end

  def merchants
    @merchants ||= MerchantRepository.new(Loader.load(file_paths[:merchants]), self)
  end

  def invoices
    @invoices ||= InvoiceRepository.new(Loader.load(file_paths[:invoices]), self)
  end

  def invoice_items
    @invoice_items ||= load_repository(file_paths[:invoice_items], InvoiceItemRepository.new)
  end

  def transactions
    @transactions ||= load_repository(file_paths[:transactions], TransactionRepository.new)
  end

  def customers
    @customers ||= load_repository(file_paths[:customers], CustomerRepository.new)
  end

  def load_repository(file_path, repository)
    repository.from_csv(file_path, self)
    return repository
  end

end
