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

  def test_it_can_find_all_items_by_merchant_id
    sales_engine = SalesEngine.from_csv({:items=>"./data/items.csv",:merchants=>"./data/merchants.csv"})
    actual_items = sales_engine.find_items_by_merchant(12334195)
    expected_item_ids = {"item_id_1"=> 263396255, "item_id_2"=> 263396517, "item_id_3"=> 263397059,
                         "item_id_4"=> 263397313, "item_id_5"=> 263397785, "item_id_6"=> 263397919,
                         "item_id_7"=> 263398179, "item_id_8"=> 263398307, "item_id_9"=> 263398427,
                         "item_id_10" => 263398653, "item_id_11" => 263399263, "item_id_12" => 263400013,
                         "item_id_13" => 263499794, "item_id_14" => 263500126, "item_id_15" => 263500424,
                         "item_id_16" => 263500990, "item_id_17" => 263501298, "item_id_18" => 263501476,
                         "item_id_19" => 263502370, "item_id_20" => 263502940}
    assert_equal actual_items[0].id, expected_item_ids["item_id_1"]
    assert_equal actual_items[1].id, expected_item_ids["item_id_2"]
    assert_equal actual_items[2].id, expected_item_ids["item_id_3"]
    assert_equal actual_items[3].id, expected_item_ids["item_id_4"]
    assert_equal actual_items[4].id, expected_item_ids["item_id_5"]
    assert_equal actual_items[5].id, expected_item_ids["item_id_6"]
    assert_equal actual_items[6].id, expected_item_ids["item_id_7"]
    assert_equal actual_items[7].id, expected_item_ids["item_id_8"]
    assert_equal actual_items[8].id, expected_item_ids["item_id_9"]
    assert_equal actual_items[9].id, expected_item_ids["item_id_10"]
    assert_equal actual_items[10].id, expected_item_ids["item_id_11"]
    assert_equal actual_items[11].id, expected_item_ids["item_id_12"]
    assert_equal actual_items[12].id, expected_item_ids["item_id_13"]
    assert_equal actual_items[13].id, expected_item_ids["item_id_14"]
    assert_equal actual_items[14].id, expected_item_ids["item_id_15"]
    assert_equal actual_items[15].id, expected_item_ids["item_id_16"]
    assert_equal actual_items[16].id, expected_item_ids["item_id_17"]
    assert_equal actual_items[17].id, expected_item_ids["item_id_18"]
    assert_equal actual_items[18].id, expected_item_ids["item_id_19"]
    assert_equal actual_items[19].id, expected_item_ids["item_id_20"]
  end

end
