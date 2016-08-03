require './test/test_helper'
require './lib/invoice_repository'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :parent,
              :invoice_repo
  def setup
    path = "./test/fixtures/invoice_repository_fixture.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @invoice_repo = InvoiceRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    assert_equal 10, invoice_repo.all.length
  end

  def test_it_can_find_all_by_customer_id
    id_1 = 389
    id_2 = 66
    id_3 = 00

    actual_1 = invoice_repo.find_all_by_customer_id(id_1)
    actual_2 = invoice_repo.find_all_by_customer_id(id_2)
    actual_3 = invoice_repo.find_all_by_customer_id(id_3)

    actual_1.map! { |invoice| invoice.id } unless actual_1.empty?
    actual_2.map! { |invoice| invoice.id } unless actual_2.empty?
    actual_3.map! { |invoice| invoice.id } unless actual_3.empty?

    assert_equal [1963], actual_1
    assert_equal [328], actual_2
    assert_equal [], actual_3
  end

  def test_it_can_find_all_by_merchant_id
    id_1 = 12337193
    id_2 = 12334113
    id_3 = 11111111

    actual_1 = invoice_repo.find_all_by_merchant_id(id_1)
    actual_2 = invoice_repo.find_all_by_merchant_id(id_2)
    actual_3 = invoice_repo.find_all_by_merchant_id(id_3)

    actual_1.map! { |invoice| invoice.id } unless actual_1.empty?
    actual_2.map! { |invoice| invoice.id } unless actual_2.empty?
    actual_3.map! { |invoice| invoice.id } unless actual_3.empty?

    assert_equal [328], actual_1
    assert_equal [1963, 2202, 2254, 2345, 2354, 2969], actual_2
    assert_equal [], actual_3
  end

  def test_it_can_find_all_by_status
    status_1 = :pending
    status_2 = :returned
    status_3 = :shipped
    status_4 = :sold

    actual_1 = invoice_repo.find_all_by_status(status_1)
    actual_2 = invoice_repo.find_all_by_status(status_2)
    actual_3 = invoice_repo.find_all_by_status(status_3)
    actual_4 = invoice_repo.find_all_by_status(status_4)

    actual_1.map! { |invoice| invoice.id } unless actual_1.empty?
    actual_2.map! { |invoice| invoice.id } unless actual_2.empty?
    actual_3.map! { |invoice| invoice.id } unless actual_3.empty?

    assert_equal [1963], actual_1
    assert_equal [2254, 224], actual_2
    assert_equal [2202, 2345, 2354, 2969, 159, 292, 328], actual_3
    assert_equal [], actual_4
  end

  def test_it_can_find_all_invoices_by_created_at
    path = "./test/fixtures/iteration04_total_revenue_by_date_find_all_invoices_by_date_created_invoices.csv"
    contents = Loader.load(path)
    invoice_repo = InvoiceRepository.new(contents, "parent")

    expected_ids = [9, 1883, 2585, 3091]
    date = Time.parse("2003-03-07")

    actual_invoices = invoice_repo.find_all_by_created_at(date)

    assert_equal 4, actual_invoices.length
    actual_invoices.each { |invoice| expected_ids.include?(invoice.id) }
  end

  def test_it_will_find_merchant_by_id
    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [263395237])
    parent.expect(:find_merchant_by_merchant_id, nil, [11111111])

    actual_merchants_1 = invoice_repo.find_merchant_by_merchant_id(263395237)
    actual_merchants_2 = invoice_repo.find_merchant_by_merchant_id(11111111)

    assert_equal "this_merchant", actual_merchants_1
    assert_equal nil, actual_merchants_2
  end

  def test_it_knows_all_the_items_on_an_invoice
    parent.expect(:find_items_on_invoice, "ITEMS", [181])
    actual_items = invoice_repo.find_items_on_invoice(181)
    assert_equal "ITEMS", actual_items
    parent.verify
  end

  def test_it_knows_all_the_transactions_on_an_invoice
    parent.expect(:find_transactions_on_invoice, "TRANSACTIONS", [181])
    actual_transactions = invoice_repo.find_transactions_on_invoice(181)
    assert_equal "TRANSACTIONS", actual_transactions
  end

  def test_it_knows_the_customer_on_an_invoice
    parent.expect(:find_customer_on_invoice, "CUSTOMER", [35])
    actual_customer = invoice_repo.find_customer_on_invoice(35)
    assert_equal "CUSTOMER", actual_customer
  end

  def test_it_knows_the_invoice_item_associated_with_an_invoice
    parent.expect(:find_invoice_items_by_invoice, "INVOICE_ITEM", ["ID"])
    actual_invoice_item = invoice_repo.find_invoice_items_by_invoice("ID")
    assert_equal "INVOICE_ITEM", actual_invoice_item
  end

end
