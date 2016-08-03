require './test/test_helper'
require './lib/loader'
require './lib/sales_engine'

class InvoiceTest < Minitest::Test
  attr_reader :test_invoice,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/invoice_fixture.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_invoice = Invoice.new(data, parent)
    end
  end

  def test_it_has_all_the_properties_of_an_invoice
    expected_id          = 181
    expected_customer_id = 35
    expected_status      = :returned
    expected_created_at  = Time.parse("2013-08-20")
    expected_updated_at  = Time.parse("2015-04-01")
    expected_merchant_id = 12334420

    assert_equal expected_id, test_invoice.id
    assert_equal expected_customer_id, test_invoice.customer_id
    assert_equal expected_status, test_invoice.status
    assert_equal expected_created_at, test_invoice.created_at
    assert_equal expected_updated_at, test_invoice.updated_at
    assert_equal expected_merchant_id, test_invoice.merchant_id
  end

  def test_invoice_has_parent
    parent.expect(:class, InvoiceRepository)
    assert_equal InvoiceRepository, test_invoice.parent.class
    assert parent.verify
  end

  def test_invoice_returns_merchant_it_is_associated_to
    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [12334420])

    actual_merchant = test_invoice.merchant

    assert_equal "this_merchant", actual_merchant
    assert parent.verify
  end

  def test_it_knows_all_the_items_on_an_invoice
    parent.expect(:find_items_on_invoice, "Lots of items", [181])

    actual_items = test_invoice.items

    assert_equal "Lots of items", actual_items
    assert parent.verify
  end

  def test_it_knows_all_the_items_on_an_invoice
    parent.expect(:find_transactions_on_invoice, "Lots of transactions", [181])

    actual_transactions = test_invoice.transactions

    assert_equal "Lots of transactions", actual_transactions
    assert parent.verify
  end

  def test_it_knows_all_the_customers_on_an_invoice
    parent.expect(:find_customer_on_invoice, "customer", [35])

    actual_customer = test_invoice.customer

    assert_equal "customer", actual_customer
    assert parent.verify
  end

  def test_it_knows_if_it_is_paid_in_full
    invoice_path = "./test/fixtures/business_intelligence_01_iteration_03_invoices_fixture.csv"
    transaction_path = "./test/fixtures/business_intelligence_01_iteration_03_transactions_fixture.csv"
    paths = {:invoices => invoice_path,
             :transactions => transaction_path}

    engine = SalesEngine.from_csv(paths)

    id_1 = 1
    id_2 = 200
    id_3 = 203
    id_4 = 204

    invoice_1 = engine.invoices.find_by_id(id_1)
    invoice_2 = engine.invoices.find_by_id(id_2)
    invoice_3 = engine.invoices.find_by_id(id_3)
    invoice_4 = engine.invoices.find_by_id(id_4)

    assert_equal true, invoice_1.is_paid_in_full?
    assert_equal true, invoice_2.is_paid_in_full?
    assert_equal false, invoice_3.is_paid_in_full?
    assert_equal false, invoice_4.is_paid_in_full?
  end

  def test_it_knows_total_price_of_invoice
    invoice_path = "./test/fixtures/business_intelligence_02_iteration_03_invoices_fixture.csv"
    invoice_item_path = "./test/fixtures/business_intelligence_02_iteration_03_invoice_items_fixture.csv"
    transaction_path = "./test/fixtures/business_intelligence_01_iteration_03_transactions_fixture.csv"
    paths = {:invoices => invoice_path,
             :invoice_items => invoice_item_path,
             :transactions => transaction_path}

    engine = SalesEngine.from_csv(paths)
    invoice = engine.invoices.all.first
    expected_total = BigDecimal("21067.77")

    assert_equal expected_total, invoice.total
  end

  def test_it_knows_all_the_invoice_items_on_an_invoice
    parent.expect(:find_invoice_items_by_invoice, "invoice_item", [181])

    actual_customer = test_invoice.invoice_item

    assert_equal "invoice_item", actual_customer
    assert parent.verify
  end

end
