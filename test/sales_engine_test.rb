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
    @test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})
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
    assert_equal 107, test_sales_engine.invoices.count
  end

  def test_it_can_find_items_by_invoice_id
    test_sales_engine = Minitest::Mock.new
    test_sales_engine.expect(:find_items_on_invoice,
                            "An array of items on invoice",
                            [100])

    items = test_sales_engine.find_items_on_invoice(100)

    assert_equal "An array of items on invoice", items
    assert test_sales_engine.verify
    # invoice_items = Minitest::Mock.new
    # array_of_invoice_items = Minitest::Mock.new
    # invoice_items.expect(:find_all_by_invoice_id, array_of_invoice_items ,[100])
    # array_of_invoice_items.
    #
    # actual_items = test_invoice.items
    #
    # assert_equal "Lots of items", actual_items
    # assert parent.verify
    #
    #
    #
    # test_invoice_id = 100
    # test_items = test_sales_engine.find_items_on_invoice(test_invoice_id)
    # expected_item_ids = [263527150, 263411601, 263430345]
    #
    # assert_equal 3, test_items.length
    # binding.pry
    # assert_equal Item, test_items.first.class
    # test_invoice_items.each do |item|
    #   assert_equal true, expected_item_ids.include?(item.id)
    # end
  end
end
