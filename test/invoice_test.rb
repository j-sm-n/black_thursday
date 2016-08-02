require './test/test_helper'
require './lib/loader'
require './lib/invoice'
require './lib/sales_engine'
require 'pry'

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
    expected_id                           = 181
    expected_customer_id                  = 35
    expected_status                       = :returned
    expected_created_at                   = Time.parse("2013-08-20")
    expected_updated_at                   = Time.parse("2015-04-01")
    expected_merchant_id                  = 12334420

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
    invalid_invoice = Invoice.new({
      id:           "2",
      customer_id:  "000",
      status:       "pending",
      created_at:   "2016-04-25",
      updated_at:   "2016-07-25",
      merchant_id:  "2"}, parent)

    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [12334420])
    parent.expect(:find_merchant_by_merchant_id, nil, [2])

    actual_merchant = test_invoice.merchant

    assert_equal "this_merchant", actual_merchant
    assert_equal nil, invalid_invoice.merchant
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
    item_path = "./test/fixtures/item.csv"
    merchant_path = "./test/fixtures/merchant.csv"
    invoice_path = "./test/fixtures/business_intelligence_01_iteration_03_invoices_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_fixture.csv"
    transaction_path = "./test/fixtures/business_intelligence_01_iteration_03_transactions_fixture.csv"
    customer_path = "./test/fixtures/customer_fixture.csv"
    paths = {:items => item_path, :merchants => merchant_path,
             :invoices => invoice_path, :invoice_items => invoice_item_path,
             :transactions => transaction_path, :customers => customer_path}

    test_sales_engine = SalesEngine.from_csv(paths)

    test_invoice_1_id = 1
    test_invoice_2_id = 200
    test_invoice_3_id = 203
    test_invoice_4_id = 204

    invoice_1 = test_sales_engine.invoices.find_by_id(test_invoice_1_id)
    invoice_2 = test_sales_engine.invoices.find_by_id(test_invoice_2_id)
    invoice_3 = test_sales_engine.invoices.find_by_id(test_invoice_3_id)
    invoice_4 = test_sales_engine.invoices.find_by_id(test_invoice_4_id)

    assert_equal true, invoice_1.is_paid_in_full?
    assert_equal true, invoice_2.is_paid_in_full?
    assert_equal false, invoice_3.is_paid_in_full?
    assert_equal false, invoice_4.is_paid_in_full?
  end

  def test_it_knows_total_price_of_invoice
    item_path = "./test/fixtures/item.csv"
    merchant_path = "./test/fixtures/merchant.csv"
    invoice_path = "./test/fixtures/business_intelligence_02_iteration_03_invoices_fixture.csv"
    invoice_item_path = "./test/fixtures/business_intelligence_02_iteration_03_invoice_items_fixture.csv"
    transaction_path = "./test/fixtures/business_intelligence_01_iteration_03_transactions_fixture.csv"
    customer_path = "./test/fixtures/customer_fixture.csv"
    paths = {:items => item_path, :merchants => merchant_path,
             :invoices => invoice_path, :invoice_items => invoice_item_path,
             :transactions => transaction_path, :customers => customer_path}

    test_sales_engine = SalesEngine.from_csv(paths)
    invoice = test_sales_engine.invoices.all.first
    expected_total = BigDecimal("21067.77")

    assert_equal expected_total, invoice.total
  end

  def test_it_knows_all_the_invoice_items_on_an_invoice
    parent.expect(:find_invoice_items_by_invoice, "invoice_item", [181])

    actual_customer = test_invoice.invoice_item

    assert_equal "invoice_item", actual_customer
    assert parent.verify
  end

  # def test_it_knows_if_it_is_pending
  #   contents = Loader.load("./test/fixtures/iteration04_invoices_pending.csv")
  #   contents.each do |data|
  #     test_invoice = Invoice.new(data, parent)
  #     if test_invoice.id == 1
  #       assert_equal true, test_invoice.pending?
  #     else
  #       assert_equal false, test_invoice.pending?
  #     end
  #   end
  # end

  def test_it_knows_if_it_is_outstanding
    transaction = Minitest::Mock.new
    transaction2 = Minitest::Mock.new

    parent.expect(:find_transactions_on_invoice, [transaction, transaction2], [181])
    transaction.expect(:result, "failed")
    transaction2.expect(:result, "success")
    assert_equal false, test_invoice.outstanding?

    assert parent.verify
    assert transaction.verify
    assert transaction2.verify
  end

  def test_it_knows_if_it_has_been_returned
    assert_equal true, test_invoice.returned?
  end

  def test_it_knows_if_it_has_been_shipped
    assert_equal false, test_invoice.shipped?
  end


end
