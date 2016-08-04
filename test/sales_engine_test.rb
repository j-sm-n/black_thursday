require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :engine

  def setup
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    invoice_item_path = "./test/fixtures/15_invoice_items.csv"
    transaction_path = "./test/fixtures/3_transactions.csv"
    customer_path = "./test/fixtures/92_customers.csv"
    paths = {:items => item_path, :merchants => merchant_path,
             :invoices => invoice_path, :invoice_items => invoice_item_path,
             :transactions => transaction_path, :customers => customer_path}
    @engine = SalesEngine.from_csv(paths)
  end

  def test_it_exists
    assert_instance_of SalesEngine, engine
  end

  def test_it_has_items
    assert_instance_of ItemRepository, engine.items
  end

  def test_it_has_merchants
    assert_instance_of MerchantRepository, engine.merchants
  end

  def test_it_has_invoices
    assert_instance_of InvoiceRepository, engine.invoices
  end

  def test_it_has_invoice_items
    assert_instance_of InvoiceItemRepository, engine.invoice_items
  end

  def test_it_has_transactions
    assert_instance_of TransactionRepository, engine.transactions
  end

  def test_it_has_customers
    assert_instance_of CustomerRepository, engine.customers
  end

  def test_it_can_create_advanced_repository
    customer_path = "./test/fixtures/92_customers.csv"
    actual = engine.create(customer_path, CustomerRepository.new)
    assert_instance_of CustomerRepository, actual
  end

  def test_it_can_parse_items_from_given_file_path
    assert_equal 9, engine.items.count
    assert_equal 3, engine.merchants.count
    assert_equal 107, engine.invoices.count
  end

end
