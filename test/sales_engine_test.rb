require './test/test_helper'
require './lib/sales_engine'
require 'pry'

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
    refute_equal 0, this_sales_engine.items.count
    refute_equal 0, this_sales_engine.merchants.count
  end

  def test_it_can_return_merchant_if_items_is_called_on_merchants
    sales_engine = SalesEngine.from_csv({
                            :items => "./data/items.csv",
                            :merchants => "./data/merchants.csv"
                          })
    ir = sales_engine.items.find_all_by_merchant_id(12337411)
    item = ir[0]
    merchant_instance = item.merchant

    assert_equal Merchant, merchant_instance.class
  end

end
