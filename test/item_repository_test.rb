require './test/test_helper'
require './lib/item_repository'

class ItemRepositoryTest < Minitest::Test
  attr_reader :parent,
              :item_repo
  def setup
    path = "./test/fixtures/9_items.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @item_repo = ItemRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    assert_equal 9, item_repo.all.length
  end

  def test_it_can_find_all_with_description
    description_1 = "milestone"
    description_2 = "personalized"
    description_3 = "dinosaur"

    actual_1 = item_repo.find_all_with_description(description_1)
    actual_2 = item_repo.find_all_with_description(description_2)
    actual_3 = item_repo.find_all_with_description(description_3)

    actual_1.map! { |item| item.id } unless actual_1.empty?
    actual_2.map! { |item| item.id } unless actual_2.empty?
    actual_3.map! { |item| item.id } unless actual_3.empty?

    assert_equal [263562118, 263564776], actual_1
    assert_equal [263457553, 263461291, 263562118, 263564776], actual_2
    assert_equal [], actual_3
  end

  def test_it_can_find_by_price
    price_1 = "9.99"
    price_2 = "12"
    price_3 = "45"

    actual_1 = item_repo.find_all_by_price(price_1)
    actual_2 = item_repo.find_all_by_price(price_2)
    actual_3 = item_repo.find_all_by_price(price_3)

    actual_1.map! { |item| item.id } unless actual_1.empty?
    actual_2.map! { |item| item.id } unless actual_2.empty?
    actual_3.map! { |item| item.id } unless actual_3.empty?

    assert_equal [263500440, 263501394], actual_1
    assert_equal [263395237], actual_2
    assert_equal [], actual_3
  end

  def test_it_can_find_all_in_price_range
    price_range_1 = Range.new(10, 25)
    price_range_2 = Range.new(5, 9.99)
    price_range_3 = Range.new(100, 150)

    actual_1 = item_repo.find_all_by_price_in_range(price_range_1)
    actual_2 = item_repo.find_all_by_price_in_range(price_range_2)
    actual_3 = item_repo.find_all_by_price_in_range(price_range_3)

    actual_1.map! { |item| item.id } unless actual_1.empty?
    actual_2.map! { |item| item.id } unless actual_2.empty?
    actual_3.map! { |item| item.id } unless actual_3.empty?

    expected_1 = [263395237, 263457553, 263459681, 263461291, 263562118, 263564776]
    expected_2 = [263500440, 263501394]
    expected_3 = []

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
  end

  def test_it_can_find_all_by_merchant_id
    merchant_id_1 = 12334141
    merchant_id_2 = 12334105
    merchant_id_3 = 11111111

    actual_1 = item_repo.find_all_by_merchant_id(merchant_id_1)
    actual_2 = item_repo.find_all_by_merchant_id(merchant_id_2)
    actual_3 = item_repo.find_all_by_merchant_id(merchant_id_3)

    actual_1.map! { |item| item.id } unless actual_1.empty?
    actual_2.map! { |item| item.id } unless actual_2.empty?
    actual_3.map! { |item| item.id } unless actual_3.empty?

    assert_equal [263395237], actual_1
    assert_equal [263396209, 263500440, 263501394], actual_2
    assert_equal [], actual_3
  end

  def test_it_will_find_merchant_by_id
    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [263395237])
    parent.expect(:find_merchant_by_merchant_id, nil, [11111111])

    actual_merchants_1 = item_repo.find_merchant_by_merchant_id(263395237)
    actual_merchants_2 = item_repo.find_merchant_by_merchant_id(11111111)

    assert_equal "this_merchant", actual_merchants_1
    assert_equal nil, actual_merchants_2
    assert parent.verify
  end
end
