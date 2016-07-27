require './test/test_helper'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
  attr_reader :test_sales_engine
  def setup
    @test_sales_engine = SalesEngine.new("./data/items_test.csv", "./data/merchants_test.csv")
  end

  def test_it_exists
    assert_instance_of SalesEngine, test_sales_engine
  end

  def test_it_has_items
    assert_instance_of ItemRepository, test_sales_engine.items
  end

  def test_it_has_merchants
    assert_instance_of MerchantRepository, test_sales_engine.merchants
  end

  def test_it_can_parse_items_from_given_file_path
    this_sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    assert_equal ItemRepository, this_sales_engine.items.class
    assert_equal MerchantRepository, this_sales_engine.merchants.class
  end

end
