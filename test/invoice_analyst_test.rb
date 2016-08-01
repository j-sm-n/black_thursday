require './test/test_helper'
require './lib/sales_analyst'
require './lib/invoice_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  attr_reader :test_sales_engine,
              :test_sales_analyst
  def setup
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoice_repository_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    @test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})

    @test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  end

  def test_it_returns_array_of_invoice_status_and_counts
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                              :merchants => merchant_path,
                                              :invoices => invoice_path,
                                              :invoice_items => invoice_item_path,
                                              :transactions => transaction_path,
                                              :customers => customer_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_status_counts = {:shipped=>55, :pending=>35, :returned=>17}
    actual_status_counts = test_sales_analyst.invoice_status_counts

    assert_equal expected_status_counts, actual_status_counts
  end

  def test_it_can_find_total_num_of_invoices
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                              :merchants => merchant_path,
                                              :invoices => invoice_path,
                                              :invoice_items => invoice_item_path,
                                              :transactions => transaction_path,
                                              :customers => customer_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_count = 107
    actual_count = test_sales_analyst.total_invoices

    assert_equal expected_count, actual_count
  end

  def test_it_can_find_percentage_of_invoices_shipped
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                              :merchants => merchant_path,
                                              :invoices => invoice_path,
                                              :invoice_items => invoice_item_path,
                                              :transactions => transaction_path,
                                              :customers => customer_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_percentage = 51.4
    actual_percentage = test_sales_analyst.invoice_status(:shipped)

    assert_equal expected_percentage, actual_percentage
  end
end
