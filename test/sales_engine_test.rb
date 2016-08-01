require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :test_sales_engine

  def setup
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    @test_sales_engine = SalesEngine.from_csv(file_paths)
  end

  def test_it_exists
    assert_instance_of SalesEngine, test_sales_engine
  end

  def test_it_has_items
    assert_instance_of ItemRepository, test_sales_engine.items
  end

  def test_it_has_merchants
    assert_instance_of MerchantRepository, test_sales_engine.merchants
  end

  def test_it_has_invoices
    assert_instance_of InvoiceRepository, test_sales_engine.invoices
  end

  def test_it_has_invoice_items
    assert_instance_of InvoiceItemRepository, test_sales_engine.invoice_items
  end

  def test_it_has_transactions
    assert_instance_of TransactionRepository, test_sales_engine.transactions
  end

  def test_it_has_customers
    assert_instance_of CustomerRepository, test_sales_engine.customers
  end

  def test_it_can_load_advanced_repository
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    assert_instance_of CustomerRepository, test_sales_engine.load_repository(customer_path, CustomerRepository.new)
  end

  def test_it_can_parse_items_from_given_file_path
    assert_equal 9, test_sales_engine.items.count
    assert_equal 3, test_sales_engine.merchants.count
    assert_equal 107, test_sales_engine.invoices.count
  end

end
