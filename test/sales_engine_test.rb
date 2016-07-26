require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test

  def test_it_exists
    this_se = SalesEngine.new("./data/items_test.csv", "./data/merchants_test.csv")
    assert_instance_of SalesEngine, this_se
  end

  def test_it_has_items
    this_se = SalesEngine.new("./data/items_test.csv", "./data/merchants_test.csv")
    assert_instance_of ItemRepository, this_se.items
  end

  def test_it_has_merchants
    this_se = SalesEngine.new("./data/items_test.csv", "./data/merchants_test.csv")
    assert_instance_of MerchantRepository, this_se.merchants
  end

  def test_it_can_parse_items_from_given_file_path
    se = SalesEngine.from_csv({
           :items     => "./data/items_test.csv",
           :merchants => "./data/merchants_test.csv",
         })
    assert_equal ItemRepository, se.items.class
    assert_equal MerchantRepository, se.merchants.class
  end

end
