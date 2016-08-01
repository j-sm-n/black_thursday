require './test/test_helper'
require './lib/invoice_repository'
require './lib/loader'
require 'pry'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :parent,
              :test_invoice_repository
  def setup
    path = "./test/fixtures/invoice_repository_fixture.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @test_invoice_repository = InvoiceRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    assert_equal 10, test_invoice_repository.all.length
  end

  def test_it_can_find_all_by_customer_id
    customer_id_1 = 389
    customer_id_2 = 66
    customer_id_3 = 00

    actual_invoices_w_customer_id_1 = test_invoice_repository.find_all_by_customer_id(customer_id_1)
    actual_invoices_w_customer_id_2 = test_invoice_repository.find_all_by_customer_id(customer_id_2)
    actual_invoices_w_customer_id_3 = test_invoice_repository.find_all_by_customer_id(customer_id_3)

    actual_invoices_w_customer_id_1.map! { |invoice| invoice.id } unless actual_invoices_w_customer_id_1.empty?
    actual_invoices_w_customer_id_2.map! { |invoice| invoice.id } unless actual_invoices_w_customer_id_2.empty?
    actual_invoices_w_customer_id_3.map! { |invoice| invoice.id } unless actual_invoices_w_customer_id_3.empty?

    assert_equal [1963], actual_invoices_w_customer_id_1
    assert_equal [328], actual_invoices_w_customer_id_2
    assert_equal [], actual_invoices_w_customer_id_3
  end

  def test_it_can_find_all_by_merchant_id
    merchant_id_1 = 12337193
    merchant_id_2 = 12334113
    merchant_id_3 = 11111111

    actual_invoices_w_merchant_id_1 = test_invoice_repository.find_all_by_merchant_id(merchant_id_1)
    actual_invoices_w_merchant_id_2 = test_invoice_repository.find_all_by_merchant_id(merchant_id_2)
    actual_invoices_w_merchant_id_3 = test_invoice_repository.find_all_by_merchant_id(merchant_id_3)

    actual_invoices_w_merchant_id_1.map! { |invoice| invoice.id } unless actual_invoices_w_merchant_id_1.empty?
    actual_invoices_w_merchant_id_2.map! { |invoice| invoice.id } unless actual_invoices_w_merchant_id_2.empty?
    actual_invoices_w_merchant_id_3.map! { |invoice| invoice.id } unless actual_invoices_w_merchant_id_3.empty?

    assert_equal [328], actual_invoices_w_merchant_id_1
    assert_equal [1963, 2202, 2254, 2345, 2354, 2969], actual_invoices_w_merchant_id_2
    assert_equal [], actual_invoices_w_merchant_id_3
  end

  def test_it_can_find_all_by_status
    status_1 = :pending
    status_2 = :returned
    status_3 = :shipped
    status_4 = :sold

    actual_invoices_w_status_1 = test_invoice_repository.find_all_by_status(status_1)
    actual_invoices_w_status_2 = test_invoice_repository.find_all_by_status(status_2)
    actual_invoices_w_status_3 = test_invoice_repository.find_all_by_status(status_3)
    actual_invoices_w_status_4 = test_invoice_repository.find_all_by_status(status_4)

    actual_invoices_w_status_1.map! { |invoice| invoice.id } unless actual_invoices_w_status_1.empty?
    actual_invoices_w_status_2.map! { |invoice| invoice.id } unless actual_invoices_w_status_2.empty?
    actual_invoices_w_status_3.map! { |invoice| invoice.id } unless actual_invoices_w_status_3.empty?

    assert_equal [1963], actual_invoices_w_status_1
    assert_equal [2254, 224], actual_invoices_w_status_2
    assert_equal [2202, 2345, 2354, 2969, 159, 292, 328], actual_invoices_w_status_3
    assert_equal [], actual_invoices_w_status_4
  end

  def test_it_will_find_merchant_by_id
    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [263395237])
    parent.expect(:find_merchant_by_merchant_id, nil, [11111111])

    actual_merchants_1 = test_invoice_repository.find_merchant_by_merchant_id(263395237)
    actual_merchants_2 = test_invoice_repository.find_merchant_by_merchant_id(11111111)

    assert_equal "this_merchant", actual_merchants_1
    assert_equal nil, actual_merchants_2
  end

  def test_it_knows_all_the_items_on_an_invoice
    parent.expect(:find_items_on_invoice, "Lots of items", [181])
    actual_items = test_invoice_repository.find_items_on_invoice(181)
    assert_equal "Lots of items", actual_items
    parent.verify
  end

  def test_it_knows_all_the_transactions_on_an_invoice
    parent.expect(:find_transactions_on_invoice, "transactions", [181])
    actual_transactions = test_invoice_repository.find_transactions_on_invoice(181)
    assert_equal "transactions", actual_transactions
  end

  def test_it_knows_the_customer_on_an_invoice
    parent.expect(:find_customer_on_invoice, "customer", [35])
    actual_customer = test_invoice_repository.find_customer_on_invoice(35)
    assert_equal "customer", actual_customer
  end

  def test_it_knows_the_invoice_item_associated_with_an_invoice
    parent.expect(:find_invoice_items_by_invoice, "invoice_item", ["invoice_id"])
    actual_invoice_item = test_invoice_repository.find_invoice_items_by_invoice("invoice_id")
    assert_equal "invoice_item", actual_invoice_item
  end

end
