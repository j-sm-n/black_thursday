require './test/test_helper'
require './lib/merchant_repository'
require './lib/loader'
require './lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({:items => "./data/items_test.csv",
                                         :merchants => "./data/merchants_test.csv",})
  end

  def test_it_exists
    test_merchant_repository = MerchantRepository.new([],sales_engine)
    assert_instance_of MerchantRepository, test_merchant_repository
  end

  def test_it_can_find_all_by_name
    contents = Loader.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    actual = test_merchant_repository.find_all_by_name("e")
    expected_names = ["MiniatureBikez", "LolaMarleys", "Keckenbauer", "perlesemoi", "GoldenRayPress", "jejum", "Urcase17"]
    actual.each do |merchant|
      assert_equal true, expected_names.include?(merchant.name)
    end
    assert_equal expected_names.length, actual.length
  end

  def test_it_can_populate_itself_with_child_merchants
    test_merchant_repository = MerchantRepository.new([], sales_engine)
    contents = Loader.load("./data/merchants_test.csv")
    actual = test_merchant_repository.populate(contents)
    assert_equal 9, actual.length
  end

  def test_initialization_populates_the_repository
    contents = Loader.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    assert_equal 9, test_merchant_repository.all.length
    refute_equal 0, test_merchant_repository.count
  end

  def test_it_finds_items_by_merchant_id
    sales_engine = SalesEngine.from_csv({:items=>"./data/items.csv",:merchants=>"./data/merchants.csv"})
    actual_items = sales_engine.merchants.find_items_by_merchant(12334195)
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
