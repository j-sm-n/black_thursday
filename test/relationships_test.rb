require './test/test_helper'
require './lib/loader'
require './lib/relationships'
require './lib/sales_engine'

class RelationshipsTest < Minitest::Test

  attr_reader :test_sales_engine

  def setup
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    @test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})
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

  def test_it_can_find_items_by_invoice_id
    skip
    invoice_item_directory = "./test/fixtures/"
    invoice_item_file = "relationships_01_iteration_03_invoice_item_fixture.csv"
    invoice_item_path = invoice_item_directory + invoice_item_file

    item_directory = "./test/fixtures/"
    item_file = "relationships_01_iteration_03_invoice_item_fixture.csv"
    item_path = invoice_item_directory + invoice_item_file

    invoice = test_sales_engine.invoices.find_by_id(106)

    actual_items_1 = invoice.items

    assert_equal 7, actual_items_1.length
    assert_equal Item, actual_items_1.first.class
  end


end
