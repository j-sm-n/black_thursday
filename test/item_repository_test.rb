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
    contents = Parser.new.load("./data/items_test.csv")
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    test_item_repository = ItemRepository.new(contents, sales_engine)
    actual = test_item_repository.find_all_by_merchant_id(12335215)
    assert_equal 263440155, actual[0].id
  end
end
