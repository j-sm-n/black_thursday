require './test/test_helper'
require './lib/sales_analyst'
require './lib/invoice_analyst'

class InvoiceAnalystTest < Minitest::Test
  attr_reader :analyst

  def setup
    invoice_path = "./test/fixtures/107_invoices.csv"
    engine = SalesEngine.from_csv({:invoices => invoice_path})
    @analyst = SalesAnalyst.new(engine)
  end

  def test_it_returns_invoice_statuses
    expect = 107
    actual = analyst.invoice_statuses.length
    assert_equal expect, actual
  end

  def test_it_groups_statuses
    expected = 55
    actual = analyst.group_statuses[:shipped].length
    assert_equal expected, actual
  end

  def test_it_returns_array_of_invoice_status_and_counts
    expected_status_counts = {:shipped=>55, :pending=>35, :returned=>17}
    actual_status_counts = analyst.invoice_status_counts

    assert_equal expected_status_counts, actual_status_counts
  end

  def test_it_can_find_total_num_of_invoices
    expected_count = 107
    actual_count = analyst.total_invoices

    assert_equal expected_count, actual_count
  end

  def test_it_can_find_percentage_of_invoices_shipped
    expected_percentage = 51.4
    actual_percentage = analyst.invoice_status(:shipped)

    assert_equal expected_percentage, actual_percentage
  end
end
