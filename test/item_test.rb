require './test/test_helper'
require './lib/item'
require './lib/loader'

class ItemTest < Minitest::Test
  attr_reader :test_item,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/item.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_item = Item.new(data, parent)
    end
  end

  def test_it_exists
    assert_instance_of Item, test_item
  end

  def test_it_has_all_the_properties_of_an_item
    expected_id          = 263406193
    expected_name        = "Shimmering Peacock"
    expected_description = "this decorative lighted wine bottle with 50 "\
                           "lights will brighten up your home, bar area "\
                           "and even act as a night light. use your ima"\
                           "gination! it would be a great conversation "\
                           "piece, a thoughtful gift, or an inspiration"\
                           "al piece. this is a unique, one of a kind b"\
                           "eautifully handcrafted wine bottle -- ready "\
                           "to display and enjoy. the individual desig"\
                           "n is the work of one artist and is inspired "\
                           "from the artist’s lakeside retreat."
    expected_unit_price  = BigDecimal.new("4500")/100
    expected_created_at  = Time.parse("2016-01-11 16:19:54 UTC")
    expected_updated_at  = Time.parse("1973-04-25 05:41:41 UTC")
    expected_merchant_id = 12334703

    assert_equal expected_id, test_item.id
    assert_equal expected_name, test_item.name
    assert_equal expected_description, test_item.description
    assert_equal expected_unit_price, test_item.unit_price
    assert_equal expected_created_at, test_item.created_at
    assert_equal expected_updated_at, test_item.updated_at
    assert_equal expected_merchant_id, test_item.merchant_id
  end

  def test_it_can_return_unit_price_as_float
    assert_equal 45, test_item.unit_price_to_dollars
  end

  def test_item_has_parent
    parent.expect(:class, ItemRepository)
    assert_equal ItemRepository, test_item.parent.class
    assert parent.verify
  end

  def test_item_returns_merchant_it_is_sold_by
    invalid_item = Item.new({
      id:           "2",
      name:         "invalid_item",
      description:  "invalid_item_description",
      unit_price:   "10000",
      created_at:   "2016-04-25 05:41:41 UTC",
      updated_at:   "2016-07-25 05:41:41 UTC",
      merchant_id:  "2"}, parent)

    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [12334703])
    parent.expect(:find_merchant_by_merchant_id, nil, [2])

    actual_merchants = test_item.merchant

    assert_equal "this_merchant", actual_merchants
    assert_equal nil, invalid_item.merchant
    assert parent.verify
  end
end
