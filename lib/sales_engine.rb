require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/loader'

class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices

  def initialize(item_file, merchant_file, invoice_file)
    @items     = ItemRepository.new(Loader.load(item_file), self)
    @merchants = MerchantRepository.new(Loader.load(merchant_file), self)
    @invoices  = InvoiceRepository.new(Loader.load(invoice_file), self)
  end

  def self.from_csv(hash_of_file_paths)
    SalesEngine.new(hash_of_file_paths[:items],
                    hash_of_file_paths[:merchants],
                    hash_of_file_paths[:invoices])
  end

  def find_merchant_by_merchant_id(id)
    merchants.find_by_id(id)
  end

  def find_items_by_merchant(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_by_merchant(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end
end
