require './test/test_helper'
require './lib/sales_analyst'

class DateAnalystTest < Minitest::Test

  def test_it_can_find_days_of_the_week_invoices_were_created
    invoice_path = "./test/fixtures/107_invoices.csv"
    engine = SalesEngine.from_csv({:invoices => invoice_path})
    analyst = SalesAnalyst.new(engine)
    invoice_days = analyst.invoice_count_per_day

    expected_day_per_invoice = {4=>19, 1=>16, 0=>13, 3=>12, 6=>20, 5=>13, 2=>14}

    assert_equal false, invoice_days.empty?
    assert_equal 7, invoice_days.count
    assert_equal expected_day_per_invoice, invoice_days
  end

  def test_it_finds_average_day_invoices_are_created
    invoice_path = "./test/fixtures/107_invoices.csv"
    engine = SalesEngine.from_csv({:invoices => invoice_path})
    analyst = SalesAnalyst.new(engine)

    assert_equal 15.29, analyst.average_invoices_per_day_created
    refute_equal 1, analyst.average_invoices_per_day_created
  end

  def test_it_knows_average_invoices_per_day_standard_deviation
    invoice_path = "./test/fixtures/107_invoices.csv"
    engine = SalesEngine.from_csv({:invoices => invoice_path})
    analyst = SalesAnalyst.new(engine)

    expected_standard_deviation = 3.15
    actual_standard_deviation = analyst.average_invoices_per_day_standard_deviation

    assert_equal expected_standard_deviation, actual_standard_deviation
  end

  def test_it_can_return_invoice_counts_that_are_more_than_one_std_dev_above
    invoice_path = "./test/fixtures/107_invoices.csv"
    engine = SalesEngine.from_csv({:invoices => invoice_path})
    analyst = SalesAnalyst.new(engine)

    expected_result = {4=>19, 6=>20}
    actual_result = analyst.top_days_more_than_one_std_deviation

    assert_equal expected_result, actual_result
  end

  def test_it_can_find_days_of_the_week_by_top_sales
    invoice_path = "./test/fixtures/107_invoices.csv"
    engine = SalesEngine.from_csv({:invoices => invoice_path})
    analyst = SalesAnalyst.new(engine)

    expected_days = ["Thursday", "Saturday"]
    actual_days = analyst.top_days_by_invoice_count

    assert_equal expected_days, actual_days
  end

  def test_it_can_find_total_revenue_by_date
    invoice_items_path = "./test/fixtures/8_invoice_items_v2.csv"
    invoice_path = "./test/fixtures/1_invoice_v3.csv"
    file_path = {:invoices => invoice_path, :invoice_items => invoice_items_path}
    engine = SalesEngine.from_csv(file_path)
    analyst = SalesAnalyst.new(engine)

    date = Time.parse("2009-02-07")
    expected_total_revenue = BigDecimal.new("21067.77")

    actual_total_revenue = analyst.total_revenue_by_date(date)

    assert_equal expected_total_revenue, actual_total_revenue
  end

  def test_it_can_total_invoice_price
    invoice_items_path = "./test/fixtures/8_invoice_items_v2.csv"
    invoice_path = "./test/fixtures/1_invoice_v3.csv"
    file_path = {:invoices => invoice_path, :invoice_items => invoice_items_path}
    engine = SalesEngine.from_csv(file_path)
    analyst = SalesAnalyst.new(engine)

    assert_equal BigDecimal.new("21067.77"), analyst.revenue_on_invoice(1)
  end

end
