require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test

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

  def test_it__knows_most_items_sold_for_merchant
    invoice_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice.csv"
    merchant_path = "./test/fixtures/iteration04_sold_item_for_merchant_merchant.csv"
    invoice_item_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice_item.csv"
    item_path = "./data/items.csv"
    file_paths = {:merchants => merchant_path,
                  :items => item_path,
                  :invoice_items => invoice_item_path,
                  :invoices => invoice_path}

    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    items_1 = test_sales_analyst.most_sold_item_for_merchant(12334189)
    items_2 = test_sales_analyst.most_sold_item_for_merchant(12334768)
    items_3 =  test_sales_analyst.most_sold_item_for_merchant(12337105)

    assert_equal 
  end



end
