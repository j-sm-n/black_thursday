require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :test_sales_engine

  def setup
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    @test_sales_engine = SalesEngine.new(item_path, merchant_path, invoice_path)
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

  def test_it_can_parse_items_from_given_file_path
    assert_equal 9, test_sales_engine.items.count
    assert_equal 3, test_sales_engine.merchants.count
    assert_equal 96, test_sales_engine.invoices.count
  end

  def test_it_can_find_merchants_by_id
    merchant = test_sales_engine.merchants.find_by_id(12337041)

    assert_equal 12337041, merchant.id
    assert_equal "MilestonesForBaby", merchant.name
  end

  def test_it_can_find_items_by_id
    item = test_sales_engine.items.find_by_id(263396209)

    assert_equal 263396209, item.id
    assert_equal "Vogue Paris Original Givenchy 2307", item.name
  end

  def test_it_can_find_invoices_by_id
    invoice = test_sales_engine.invoices.find_by_id(478)

    assert_equal 478, invoice.id
    assert_equal :shipped, invoice.status
  end
end
