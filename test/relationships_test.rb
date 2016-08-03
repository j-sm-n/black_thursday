require './test/test_helper'
require './lib/relationships'
require './lib/sales_engine'

class RelationshipsTest < Minitest::Test

  def test_it_can_find_merchants_by_id
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    path = {:items => item_path, :merchants => merchant_path,
            :invoices => invoice_path}

    engine = SalesEngine.from_csv(path)

    merchant = engine.merchants.find_by_id(12337041)

    assert_equal 12337041, merchant.id
    assert_equal "MilestonesForBaby", merchant.name
  end

  def test_it_can_find_items_by_id
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    path = {:items => item_path, :merchants => merchant_path,
            :invoices => invoice_path}

    engine = SalesEngine.from_csv(path)

    item = engine.items.find_by_id(263396209)

    assert_equal 263396209, item.id
    assert_equal "Vogue Paris Original Givenchy 2307", item.name
  end

  def test_it_can_find_invoices_by_id
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    path = {:items => item_path, :merchants => merchant_path,
            :invoices => invoice_path}

    engine = SalesEngine.from_csv(path)

    invoice = engine.invoices.find_by_id(478)

    assert_equal 478, invoice.id
    assert_equal :shipped, invoice.status
  end

  def test_it_can_find_items_by_invoice_id
    item_path = "./test/fixtures/relationships_01_iteration_03_item_fixture.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    invoice_item_path = "./test/fixtures/relationships_01_iteration_03_invoice_item_fixture.csv"
    path = {:items => item_path,
            :invoices => invoice_path,
            :invoice_items => invoice_item_path}
    engine = SalesEngine.from_csv(path)

    expected_ids = [263396255, 263503514]
    items = engine.find_items_on_invoice(106)
    assert_equal 2, items.length
    assert_equal Item, items.first.class
    items.each { |item| assert_equal true, expected_ids.include?(item.id) }
  end

  def test_it_can_find_transactions_on_invoice
    invoice_path = "./test/fixtures/107_invoices.csv"
    transaction_path = "./test/fixtures/relationships_01_iteration_03_transaction_fixture.csv"
    path = {:invoices => invoice_path,
            :transactions => transaction_path}
    engine = SalesEngine.from_csv(path)

    expected_transaction_id = 4705
    actual_transactions = engine.find_transactions_on_invoice(106)
    assert_equal 1, actual_transactions.length
    assert_equal 4705, actual_transactions.first.id
  end

  def test_it_can_find_customers_by_invoice_id
    invoice_path = "./test/fixtures/107_invoices.csv"
    customer_path = "./test/fixtures/relationships_01_iteration_03_customer_fixture.csv"
    path = {:invoices => invoice_path,
            :customers => customer_path}
    engine = SalesEngine.from_csv(path)

    expected_customer_id = 22
    actual_customer = engine.find_customer_on_invoice(22)
    assert_equal Customer, actual_customer.class
    assert_equal 22, actual_customer.id
  end

  def test_it_can_find_invoice_from_invoice_id_off_transaction
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    path = {:items => item_path, :merchants => merchant_path,
            :invoices => invoice_path}

    engine = SalesEngine.from_csv(path)

    assert_equal 941, engine.find_invoice_on_transaction(941).id
  end

  def test_it_can_find_customers_from_merchant_id
    merchant_path = "./test/fixtures/relationships_01_iteration_03_merchant_fixture.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    customer_path = "./test/fixtures/relationships_02_iteration_03_customer_fixture.csv"
    path = {:merchants => merchant_path,
            :invoices => invoice_path,
            :customers => customer_path}
    engine = SalesEngine.from_csv(path)

    merchant_id = 12334176
    customer_id = [30, 96, 121]

    customers = engine.find_customers_of_merchant(merchant_id)
    assert_equal 3, customers.length
    assert_instance_of Customer, customers.first
    customers.each do |customer|
      assert_equal true, customer_id.include?(customer.id)
    end
  end

  def test_it_finds_invoice_items_by_invoice
    invoice_path = "./test/fixtures/business_intelligence_02_iteration_03_invoices_fixture.csv"
    invoice_item_path = "./test/fixtures/business_intelligence_02_iteration_03_invoice_items_fixture.csv"
    path = {:invoices => invoice_path,
            :invoice_items => invoice_item_path}
    engine = SalesEngine.from_csv(path)

    invoice_id = 1
    expected_invoice_item_ids = [1,2,3,4,5,6,7,8]
    invoice_items = engine.find_invoice_items_by_invoice(invoice_id)
    assert_equal 8, invoice_items.length
    assert_instance_of InvoiceItem, invoice_items.first
    invoice_items.each do |invoice_item|
      assert_equal true, expected_invoice_item_ids.include?(invoice_item.id)
    end
  end
end
