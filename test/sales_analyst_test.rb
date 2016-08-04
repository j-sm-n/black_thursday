require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  attr_reader :test_sales_analyst

  def setup
    item_path = "./test/fixtures/item.csv"
    merchant_path = "./test/fixtures/merchant.csv"
    invoice_path = "./test/fixtures/1_invoice_v2.csv"
    invoice_item_path = "./test/fixtures/1_invoice_item.csv"
    transaction_path = "./test/fixtures/1_transaction.csv"
    customer_path = "./test/fixtures/1_customer.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    @test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  end

  def test_it_has_a_sales_engine_and_child_item_repository
    assert_instance_of ItemRepository, test_sales_analyst.items
  end

  def test_it_has_a_sales_engine_and_child_merchant_repository
    assert_instance_of MerchantRepository, test_sales_analyst.merchants
  end

  def test_it_has_a_sales_engine_and_child_invoice_repository
    assert_instance_of InvoiceRepository, test_sales_analyst.invoices
  end

  def test_it_has_a_sales_engine_and_child_invoice_item_repository
    assert_instance_of InvoiceItemRepository, test_sales_analyst.invoice_items
  end

  def test_it_has_a_sales_engine_and_child_invoice_item_repository
    assert_instance_of TransactionRepository, test_sales_analyst.transactions
  end

  def test_it_has_a_sales_engine_and_child_invoice_item_repository
    assert_instance_of CustomerRepository, test_sales_analyst.customers
  end
end
