require './test/test_helper'
require './lib/item_repository'
require './lib/loader'

class ItemRepositoryTest < Minitest::Test
  attr_reader :parent,
              :test_item_repository
  def setup
    path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @test_item_repository = ItemRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    assert_equal 9, test_item_repository.all.length
  end

  def test_it_can_find_all_with_description
    description_1 = "milestone"
    description_2 = "personalized"
    description_3 = "dinosaur"

    actual_items_w_description_1 = test_item_repository.find_all_with_description(description_1)
    actual_items_w_description_2 = test_item_repository.find_all_with_description(description_2)
    actual_items_w_description_3 = test_item_repository.find_all_with_description(description_3)

    actual_items_w_description_1.map! { |item| item.id } unless actual_items_w_description_1.empty?
    actual_items_w_description_2.map! { |item| item.id } unless actual_items_w_description_2.empty?
    actual_items_w_description_3.map! { |item| item.id } unless actual_items_w_description_3.empty?

    assert_equal [263562118, 263564776], actual_items_w_description_1
    assert_equal [263457553, 263461291, 263562118, 263564776], actual_items_w_description_2
    assert_equal [], actual_items_w_description_3
  end

  def test_it_can_find_by_price
    price_1 = "9.99"
    price_2 = "12"
    price_3 = "45"

    actual_items_w_price_1 = test_item_repository.find_all_by_price(price_1)
    actual_items_w_price_2 = test_item_repository.find_all_by_price(price_2)
    actual_items_w_price_3 = test_item_repository.find_all_by_price(price_3)

    actual_items_w_price_1.map! { |item| item.id } unless actual_items_w_price_1.empty?
    actual_items_w_price_2.map! { |item| item.id } unless actual_items_w_price_2.empty?
    actual_items_w_price_3.map! { |item| item.id } unless actual_items_w_price_3.empty?

    assert_equal [263500440, 263501394], actual_items_w_price_1
    assert_equal [263395237], actual_items_w_price_2
    assert_equal [], actual_items_w_price_3
  end

  def test_it_can_find_all_in_price_range
    price_range_1 = Range.new(10, 25)
    price_range_2 = Range.new(5, 9.99)
    price_range_3 = Range.new(100, 150)

    actual_items_in_price_range_1 = test_item_repository.find_all_by_price_in_range(price_range_1)
    actual_items_in_price_range_2 = test_item_repository.find_all_by_price_in_range(price_range_2)
    actual_items_in_price_range_3 = test_item_repository.find_all_by_price_in_range(price_range_3)

    actual_items_in_price_range_1.map! { |item| item.id } unless actual_items_in_price_range_1.empty?
    actual_items_in_price_range_2.map! { |item| item.id } unless actual_items_in_price_range_2.empty?
    actual_items_in_price_range_3.map! { |item| item.id } unless actual_items_in_price_range_3.empty?

    assert_equal [263395237, 263457553, 263459681, 263461291, 263562118, 263564776], actual_items_in_price_range_1
    assert_equal [263500440, 263501394], actual_items_in_price_range_2
    assert_equal [], actual_items_in_price_range_3
  end

  def test_it_can_find_all_by_merchant_id
    merchant_id_1 = 12334141
    merchant_id_2 = 12334105
    merchant_id_3 = 11111111

    actual_items_w_merchant_id_1 = test_item_repository.find_all_by_merchant_id(merchant_id_1)
    actual_items_w_merchant_id_2 = test_item_repository.find_all_by_merchant_id(merchant_id_2)
    actual_items_w_merchant_id_3 = test_item_repository.find_all_by_merchant_id(merchant_id_3)

    actual_items_w_merchant_id_1.map! { |item| item.id } unless actual_items_w_merchant_id_1.empty?
    actual_items_w_merchant_id_2.map! { |item| item.id } unless actual_items_w_merchant_id_2.empty?
    actual_items_w_merchant_id_3.map! { |item| item.id } unless actual_items_w_merchant_id_3.empty?

    assert_equal [263395237], actual_items_w_merchant_id_1
    assert_equal [263396209, 263500440, 263501394], actual_items_w_merchant_id_2
    assert_equal [], actual_items_w_merchant_id_3
  end

  def test_it_will_find_merchant_by_id
    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [263395237])
    parent.expect(:find_merchant_by_merchant_id, nil, [11111111])

    actual_merchants_1 = test_item_repository.find_merchant_by_merchant_id(263395237)
    actual_merchants_2 = test_item_repository.find_merchant_by_merchant_id(11111111)

    assert_equal "this_merchant", actual_merchants_1
    assert_equal nil, actual_merchants_2
    assert parent.verify
  end
end
