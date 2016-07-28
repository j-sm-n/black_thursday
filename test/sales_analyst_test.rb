require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  def test_sa_exitst
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_instance_of SalesAnalyst, sales_analyst
  end

  def test_it_has_access_to_all_items
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 9, sales_analyst.items.count
    assert_equal "510+ RealPush Icon Set", sales_analyst.items[0].name
  end

  def test_it_has_access_to_all_merchants
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 3, sales_analyst.merchants.count
    assert_equal "jejum", sales_analyst.merchants[0].name
  end

  def test_it_can_find_how_many_items_merchants_sell
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal [1, 3, 5], sales_analyst.find_how_many_items_merchants_sell
  end

  def test_it_can_find_average_of_items_sold
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 3.0, sales_analyst.average_item_count_per_merchant
  end

  def test_it_finds_the_variance_of_items
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)
    sales_analyst.find_how_many_items_merchants_sell

    assert_equal 2.6666666666666665, sales_analyst.find_variance_of_items_sold
  end

  def test_it_finds_standard_deviation_of_items_sold
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)
    sales_analyst.find_how_many_items_merchants_sell
    sales_analyst.find_variance_of_items_sold

    assert_equal 1.632993161855452, sales_analyst.average_items_per_merchant_standard_deviation
  end

  def test_can_produce_list_of_merchants_who_sell_like_ballers
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)
    sales_analyst.find_how_many_items_merchants_sell
    sales_analyst.find_variance_of_items_sold
  end
end
