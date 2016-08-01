require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class DateAnalystTest < Minitest::Test

  def test_it_can_find_days_of_the_week_invoices_were_created
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    test_sales_engine = SalesEngine.from_csv({:invoices => invoice_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)
    invoice_days = test_sales_analyst.invoice_count_per_day

    expected_day_per_invoice = {4=>19, 1=>16, 0=>13, 3=>12, 6=>20, 5=>13, 2=>14}

    assert_equal false, invoice_days.empty?
    assert_equal 7, invoice_days.count
    assert_equal expected_day_per_invoice, invoice_days
  end

  def test_it_finds_average_day_invoices_are_created
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    test_sales_engine = SalesEngine.from_csv({:invoices => invoice_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    assert_equal 15.29, test_sales_analyst.average_invoices_per_day_created
    refute_equal 1, test_sales_analyst.average_invoices_per_day_created
  end

  def test_it_knows_average_invoices_per_day_standard_deviation
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    test_sales_engine = SalesEngine.from_csv({:invoices => invoice_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_standard_deviation = 3.15
    actual_standard_deviation = test_sales_analyst.average_invoices_per_day_standard_deviation

    assert_equal expected_standard_deviation, actual_standard_deviation
  end

  def test_it_can_return_invoice_counts_that_are_more_than_one_std_dev_above
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    test_sales_engine = SalesEngine.from_csv({:invoices => invoice_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_result = {4=>19, 6=>20}
    actual_result = test_sales_analyst.top_days_more_than_one_std_deviation

    assert_equal expected_result, actual_result
  end

  def test_it_can_find_days_of_the_week_by_top_sales
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    test_sales_engine = SalesEngine.from_csv({:invoices => invoice_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_days = ["Thursday", "Saturday"]
    actual_days = test_sales_analyst.top_days_by_invoice_count

    assert_equal expected_days, actual_days
  end


end
