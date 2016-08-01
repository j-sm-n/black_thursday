require './test/test_helper'
require './lib/sales_analyst'
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

  def test_it_can_find_days_of_the_week_invoices_were_created
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
    invoice_days = test_sales_analyst.invoice_count_per_day

    expected_day_per_invoice = {4=>19, 1=>16, 0=>13, 3=>12, 6=>20, 5=>13, 2=>14}

    assert_equal false, invoice_days.empty?
    assert_equal 7, invoice_days.count
    assert_equal expected_day_per_invoice, invoice_days
  end

  def test_it_finds_average_day_invoices_are_created
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

    assert_equal 15.29, test_sales_analyst.average_invoices_per_day_created
    refute_equal 1, test_sales_analyst.average_invoices_per_day_created
  end

  def test_it_knows_average_invoices_per_day_standard_deviation
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
    expected_standard_deviation = 3.15
    actual_standard_deviation = test_sales_analyst.average_invoices_per_day_standard_deviation

    assert_equal expected_standard_deviation, actual_standard_deviation
  end

  def test_it_can_return_invoice_counts_that_are_more_than_one_std_dev_above
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
    expected_result = {4=>19, 6=>20}
    actual_result = test_sales_analyst.top_days_more_than_one_std_deviation

    assert_equal expected_result, actual_result
  end

  def test_it_can_find_days_of_the_week_by_top_sales
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

    expected_days = ["Thursday", "Saturday"]
    actual_days = test_sales_analyst.top_days_by_invoice_count

    assert_equal expected_days, actual_days
  end
end
