require './test/test_helper'
require './lib/item_repository'
require './lib/parser'
require './lib/sales_engine'
require 'pry'

class ItemRepositoryTest < Minitest::Test
  def test_initialization_populates_the_repository
    contents = Parser.new.load("./data/items_test.csv")
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    test_item_repository = ItemRepository.new(contents, sales_engine)
    assert_equal 10, test_item_repository.all.length
    refute_equal 0, test_item_repository.count
  end

  def test_it_can_find_all_with_description
    contents = Parser.new.load("./data/items_test.csv")
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    test_item_repository = ItemRepository.new(contents, sales_engine)
    expected_ids = [263435825, 263440607, 263440363, 263437771,
                    263439003, 263420519, 263423509, 263440155,
                    263417331, 263414425]
    actually_all_the_items_with_description = test_item_repository.find_all_with_description("e")
    actually_all_the_items_with_description.each do |item|
      assert_equal true, expected_ids.include?(item.id)
    end
    actual_2 = test_item_repository.find_all_with_description("Lorum Ipsum")
    assert_equal [], actual_2
  end

  def test_it_can_find_by_price
    contents = Parser.new.load("./data/items_test.csv")
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    test_item_repository = ItemRepository.new(contents, sales_engine)
    expected_ids = [263435825, 263423509]
    actual_1 = test_item_repository.find_all_by_price(100)
    refute_equal [], actual_1
    assert_equal expected_ids[0], actual_1[0].id
    assert_equal false, actual_1.include?(expected_ids[1])

    actual_2 = test_item_repository.find_all_by_price(0)
    assert_equal [], actual_2
  end

  def test_it_can_find_all_in_price_range
    contents = Parser.new.load("./data/items_test.csv")
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    test_item_repository = ItemRepository.new(contents, sales_engine)
    expected_ids = [263435825, 263440607, 263440363, 263437771,
                    263439003, 263420519, 263423509, 263440155,
                    263417331, 263414425]
    range_1 = Range.new(0, 1000000)
    range_2 = Range.new(0, 1)
    actual = test_item_repository.find_all_by_price_in_range(range_1)
    actual.each do |item|
      assert_equal true, expected_ids.include?(item.id)
    end
    assert_equal expected_ids.length, actual.length
    actual_2 = test_item_repository.find_all_by_price_in_range(range_2)
    assert_equal [], actual_2
  end

  def test_it_can_find_all_by_merchant_id
    sales_engine = SalesEngine.from_csv({:items=>"./data/items.csv",:merchants=>"./data/merchants.csv"})
    actual_items = sales_engine.items.find_all_by_merchant_id(12334195)
    expected_item_ids = {"item_id_1"=> 263396255, "item_id_2"=> 263396517,
                         "item_id_3"=> 263397059, "item_id_4"=> 263397313,
                         "item_id_5"=> 263397785, "item_id_6"=> 263397919,
                         "item_id_7"=> 263398179, "item_id_8"=> 263398307,
                         "item_id_9"=> 263398427, "item_id_10" => 263398653,
                         "item_id_11" => 263399263, "item_id_12" => 263400013,
                         "item_id_13" => 263499794, "item_id_14" => 263500126,
                         "item_id_15" => 263500424, "item_id_16" => 263500990,
                         "item_id_17" => 263501298, "item_id_18" => 263501476,
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

  def test_it_will_find_merchant_by_id
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      })
    item_repo = se.items
    merchant = item_repo.find_merchant_by_merchant_id(12334105)
    assert_equal Merchant, merchant.class
    assert_equal 12334105, merchant.id
  end
end
