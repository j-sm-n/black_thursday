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
    item_path = "./test/fixtures/relationships_01_iteration_03_item_fixture.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/relationships_01_iteration_03_invoice_item_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})

    expected_ids = [263396255, 263503514]
    items = test_sales_engine.find_items_on_invoice(106)
    assert_equal 2, items.length
    assert_equal Item, items.first.class
    items.each { |item| assert_equal true, expected_ids.include?(item.id) }
  end

  def test_it_can_find_transactions_on_invoice
    item_path = "./test/fixtures/relationships_01_iteration_03_item_fixture.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/relationships_01_iteration_03_invoice_item_fixture.csv"
    transaction_path = "./test/fixtures/relationships_01_iteration_03_transaction_fixture.csv"
    customer_path = "./test/fixtures/relationships_01_iteration_03_customer_fixture.csv"
    test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})
    expected_transaction_id = 4705
    actual_transactions = test_sales_engine.find_transactions_on_invoice(106)
    assert_equal 1, actual_transactions.length
    assert_equal 4705, actual_transactions.first.id
  end

  def test_it_can_find_customers_by_invoice_id
    item_path = "./test/fixtures/relationships_01_iteration_03_item_fixture.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/relationships_01_iteration_03_invoice_item_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/relationships_01_iteration_03_customer_fixture.csv"
    test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})

    expected_customer_id = 22
    actual_customer = test_sales_engine.find_customer_on_invoice(22)
    assert_equal Customer, actual_customer.class
    assert_equal 22, actual_customer.id
  end

  def test_it_can_find_invoice_from_invoice_id_off_transaction
    # mock_sales_engine = Minitest::Mock.new
    # mock_invoice_repository = Minitest::Mock.new
    # mock_sales_engine.expect(:find_invoice_on_transaction, mock_invoice_repository, ["invoice_id"])
    # mock_invoice_repository.expect(:find_by_id, "invoice", ["invoice_id"])
    # an_invoice_repository = mock_sales_engine.find_invoice_on_transaction("invoice_id")
    # invoice = an_invoice_repository.find_by_id("invoice_id")
    #
    # assert_equal "invoice", invoice
    # assert mock_sales_engine.verify
    # assert mock_invoice_repository.verify

    assert_equal 941, test_sales_engine.find_invoice_on_transaction(941).id
  end



end
