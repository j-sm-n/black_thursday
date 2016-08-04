require './test/test_helper'
require './lib/merchant_item_analyst'
require './lib/sales_analyst'
require 'pry'

class MerchantItemAnalystTest < Minitest::Test
  attr_reader :mi_anlyst

  def setup
    invoice_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice.csv"
    merchant_path = "./test/fixtures/iteration04_sold_item_for_merchant_merchant.csv"
    invoice_item_path = "./test/fixtures/134_invoice_items.csv"
    transaction_path = "./data/transactions.csv"
    item_path = "./data/items.csv"
    file_paths = {:merchants => merchant_path,
                  :items => item_path,
                  :invoice_items => invoice_item_path,
                  :invoices => invoice_path,
                  :transactions => transaction_path}

    engine = SalesEngine.from_csv(file_paths)
    parent_analyst = SalesAnalyst.new(engine)
    @mi_anlyst = MerchantItemAnalyst.new(12337105, parent_analyst)
  end

  def test_it_can_find_a_merchants_paid_in_full_invoices
    invoices = mi_anlyst.merchant_paid_in_full_invoices

    assert_equal 7, invoices.length
  end

  def test_it_can_find_paid_in_full_invoice_items
    invoice_items = mi_anlyst.merchant_paid_in_full_invoice_items

    assert_equal 35, invoice_items.length
  end

  def test_it_can_group_invoice_items_by_quantity
    grouped_invoice_items = mi_anlyst.group_invoice_items_by_quantity

    assert_equal 10, grouped_invoice_items.length
    assert_equal (1..10).to_a, grouped_invoice_items.keys.sort
  end

  def test_it_can_group_invoice_items_by_revenue
    grouped_invoice_items = mi_anlyst.group_invoice_items_by_revenue
    actual = grouped_invoice_items.keys.include?(BigDecimal.new(179376)/100)

    assert_equal 34, grouped_invoice_items.length
    assert_equal true, actual
  end

  def test_it_can_find_the_max_quantity_invoice_items
    invoice_items = mi_anlyst.max_quantity_invoice_items

    assert_equal 4, invoice_items.length
    assert_equal 263431273, invoice_items.first.item_id
  end

  def test_it_can_find_the_max_revenue_invoice_items
    invoice_items = mi_anlyst.max_revenue_invoice_items

    assert_equal 1, invoice_items.length
    assert_equal 263463003, invoice_items.first.item_id
  end

  def test_it_can_find_most_sold_item_for_merchant
    items = mi_anlyst.most_sold_item_for_merchant

    assert_equal 4, items.length
    assert_instance_of Item, items.first
    assert_equal 263431273, items.first.id
  end

  def test_it_can_find_best_item_for_merchant
    items = mi_anlyst.best_item_for_merchant

    assert_instance_of Item, items
    assert_equal 263463003, items.id
  end

end
