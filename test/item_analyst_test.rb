require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
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

  def test_it_can_find_all_non_returned_invoices_for_merchant
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

    id = 12337105
    expected_invoice_ids = [108, 145, 481, 728, 2878, 3074, 3950, 4878]
    invoices = test_sales_analyst.merchant_invoices_that_are_not_returned(id)

    assert_equal 8, invoices.length
    invoices.each do |invoice|
      assert_equal true, expected_invoice_ids.include?(invoice.id)
    end
  end

  # def test_it_can_group_invoice_items_by_quantity
  #   invoice_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice.csv"
  #   merchant_path = "./test/fixtures/iteration04_sold_item_for_merchant_merchant.csv"
  #   invoice_item_path = "./test/fixtures/iteration04_sold_item_for_merchant_invoice_item.csv"
  #   item_path = "./data/items.csv"
  #   file_paths = {:merchants => merchant_path,
  #                 :items => item_path,
  #                 :invoice_items => invoice_item_path,
  #                 :invoices => invoice_path}
  #
  #   test_sales_engine = SalesEngine.from_csv(file_paths)
  #   test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  #
  #   id = 2878
  #   expected_quantities = [10, 8, 3, 1]
  #   actual_quantities = test_sales_analyst.invoice_items_of_invoice_quantities(id).keys
  #
  #   assert_equal expected_quantities, actual_quantities
  # end

  def test_it_knows_highest_quantity_invoice_item_by_invoice
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

    invoice_id_1 = 108
    invoice_item_id_1 = 508

    invoice_id_2 = 2878
    invoice_item_id_2 = 12791
    # invoice_item_id_2 = [12791, 12795]

    invoice_id_3 = 4878
    invoice_item_id_3 = 21723

    expected_1 = test_sales_analyst.invoice_items.find_by_id(invoice_item_id_1)
    expected_2 = test_sales_analyst.invoice_items.find_by_id(invoice_item_id_2)
    # expected_2 = test_sales_analyst.invoice_items.find_by_id(invoice_item_id_2[0])
    # expected_3 = test_sales_analyst.invoice_items.find_by_id(invoice_item_id_2[1])
    expected_3 = test_sales_analyst.invoice_items.find_by_id(invoice_item_id_3)

    actual_1 = test_sales_analyst.highest_quantity_invoice_items_by_invoice(invoice_id_1)
    # binding.pry
    actual_2 = test_sales_analyst.highest_quantity_invoice_items_by_invoice(invoice_id_2)
    actual_3 = test_sales_analyst.highest_quantity_invoice_items_by_invoice(invoice_id_3)

    assert_equal expected_1, actual_1.first
    assert_equal expected_2, actual_2.first
    assert_equal expected_3, actual_3.first
    # assert_equal expected_4, actual_3.first
  end

  def test_it_gets_all_highest_quantity_invoice_items_of_merchant
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

    invoice_items = test_sales_analyst.get_all_highest_quantity_invoice_items_of_merchant(12337105)
    assert 9, invoice_items.length
  end

  def test_it_gets_all_highest_quantity_invoice_items_of_merchant
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

    grouping = test_sales_analyst.group_highest_quantity_invoice_items_by_quantity(12337105)
    assert_equal [10, 9, 7, 8, 1], grouping.keys
  end

  def test_it_finds_highest_quantity_invoice_items
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

    invoice_items = test_sales_analyst.highest_quantity_invoice_items(12337105)
    assert_equal 4, invoice_items.length
  end

  def test_it_knows_most_items_sold_for_merchant
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

    item_263524984 = items_1.find { |item| item.id == 263524984 }
    item_263549386 = items_2.find { |item| item.id == 263549386 }

    assert_equal 263524984, item_263524984.id
    assert_equal 263549386, item_263549386.id
    # binding.pry
    assert_equal 4, items_3.length
  end

end
