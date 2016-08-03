require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class ItemAnalystTest < Minitest::Test
  attr_reader :test_sales_analyst

  def setup
    invoice_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice.csv"
    merchant_path = "./test/fixtures/iteration04_sold_item_for_merchant_merchant.csv"
    invoice_item_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice_item.csv"
    transaction_path = "./data/transactions.csv"
    item_path = "./data/items.csv"
    file_paths = {:merchants => merchant_path,
                  :items => item_path,
                  :invoice_items => invoice_item_path,
                  :invoices => invoice_path,
                  :transactions => transaction_path}

    test_sales_engine = SalesEngine.from_csv(file_paths)
    @test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  end

  def test_it_knows_golden_items
    item_path = "./test/fixtures/sales_analyst_golden_items.csv"

    test_sales_engine = SalesEngine.from_csv({:items => item_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_golden_item_ids = [263426247, 263426657]

    actual_golden_items = test_sales_analyst.golden_items
    assert_equal false, actual_golden_items.nil?

    actual_golden_item_ids = actual_golden_items.map { |item| item.id }

    assert_equal expected_golden_item_ids, actual_golden_item_ids
  end

  def test_it_can_find_a_merchants_paid_in_full_invoices
    invoices = test_sales_analyst.merchant_paid_in_full_invoices(12337105)
    assert_equal 7, invoices.length
  end

  def test_it_can_find_paid_in_full_invoice_items
    id = 12337105
    invoice_items = test_sales_analyst.merchant_paid_in_full_invoice_items(id)
    assert_equal 35, invoice_items.length
  end

  def test_it_can_group_invoice_items_by_quantity
    id = 12337105
    grouped_invoice_items = test_sales_analyst.group_invoice_items_by_quantity(id)
    assert_equal 10, grouped_invoice_items.length
    assert_equal (1..10).to_a, grouped_invoice_items.keys.sort
  end

  def test_it_can_group_invoice_items_by_revenue
    id = 12337105
    grouped_invoice_items = test_sales_analyst.group_invoice_items_by_revenue(id)
    assert_equal 34, grouped_invoice_items.length
    assert_equal true, grouped_invoice_items.keys.include?(BigDecimal.new(179376)/100)
  end

  def test_it_can_find_the_max_quantity_invoice_items
    id = 12337105
    invoice_items = test_sales_analyst.max_quantity_invoice_items(id)
    assert_equal 4, invoice_items.length
    assert_equal 263431273, invoice_items.first.item_id
  end

  def test_it_can_find_the_max_revenue_invoice_items
    id = 12337105
    invoice_items = test_sales_analyst.max_revenue_invoice_items(id)
    assert_equal 1, invoice_items.length
    assert_equal 263463003, invoice_items.first.item_id
  end

  def test_it_can_find_most_sold_item_for_merchant
    merchant_id = 12337105
    items = test_sales_analyst.most_sold_item_for_merchant(merchant_id)
    assert_equal 4, items.length
    assert_instance_of Item, items.first
    assert_equal 263431273, items.first.id
  end

  def test_it_can_find_best_item_for_merchant
    merchant_id = 12337105
    items = test_sales_analyst.best_item_for_merchant(merchant_id)
    assert_instance_of Item, items
    assert_equal 263463003, items.id
  end

end
