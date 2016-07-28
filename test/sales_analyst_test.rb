require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  def test_sa_exitst
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_instance_of SalesAnalyst, sales_analyst
  end

  def test_it_has_access_to_all_items
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 10, sales_analyst.item_repo.count
    assert_equal "Handpainted HP Needlepoint Canvas &quot;Beautiful Shabbat&quot; Bracha Lavee BL32TB Judaica NWT! 211 dollars", sales_analyst.item_repo.repository[0].name
  end

  def test_it_has_access_to_all_merchants
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 9, sales_analyst.merchant_repo.count
    assert_equal "Shopin1901", sales_analyst.merchant_repo.repository[0].name
  end
end
