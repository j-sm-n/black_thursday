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

  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(item_path, merchant_path, invoice_path, invoice_item_path,
                 transaction_path, customer_path)

    @items         = ItemRepository.new(Loader.load(item_path), self)
    @merchants     = MerchantRepository.new(Loader.load(merchant_path), self)
    @invoices      = InvoiceRepository.new(Loader.load(invoice_path), self)
    @invoice_items = InvoiceItemRepository.new
    @transactions  = TransactionRepository.new
    @customers     = CustomerRepository.new

    invoice_items.from_csv(invoice_item_path, self)
    transactions.from_csv(transaction_path, self)
    customers.from_csv(customer_path, self)
  end

  def self.from_csv(hash_of_file_paths)
    SalesEngine.new(hash_of_file_paths[:items],
                    hash_of_file_paths[:merchants],
                    hash_of_file_paths[:invoices],
                    hash_of_file_paths[:invoice_items],
                    hash_of_file_paths[:transactions],
                    hash_of_file_paths[:customers])

  end

end
