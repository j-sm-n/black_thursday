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

    assert_equal 9, sales_analyst.item_repo.count
    assert_equal "510+ RealPush Icon Set", sales_analyst.item_repo.repository[0].name
  end

  def test_it_has_access_to_all_merchants
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 3, sales_analyst.merchant_repo.count
    assert_equal "jejum", sales_analyst.merchant_repo.repository[0].name
  end

  def test_it_can_find_how_many_items_merchants_sell
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal [1, 3, 5], sales_analyst.find_how_many_items_merchants_sell
    # returns array of the number of items each merchant in a data set sells
  end
end
