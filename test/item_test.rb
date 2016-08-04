require './test/test_helper'
require './lib/item'
require './lib/item_repository'

class ItemTest < Minitest::Test
  attr_reader :test_item,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/1_item.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_item = Item.new(data, parent)
    end
  end

  def test_it_exists
    assert_instance_of Item, test_item
  end

  def test_it_has_all_the_properties_of_an_item
    description    = "This decorative lighted wine bottle with 50 "\
                     "lights will brighten up your home, bar area "\
                     "and even act as a night light. Use your imag"\
                     "ination! It would be a great conversation pi"\
                     "ece, a thoughtful gift, or an inspirational "\
                     "piece. This is a unique, one of a kind beaut"\
                     "ifully handcrafted wine bottle -- ready to d"\
                     "isplay and enjoy. The individual design is t"\
                     "he work of one artist and is inspired from t"\
                     "he artist’s lakeside retreat."

    expected_id                           = 263406193
    expected_name                         = "Shimmering Peacock"
    expected_description                  = description
    expected_case_insensitive_description = description.downcase
    expected_unit_price                   = BigDecimal.new("4500")/100
    expected_created_at                   = Time.parse("2016-01-11 16:19:54 UTC")
    expected_updated_at                   = Time.parse("1973-04-25 05:41:41 UTC")
    expected_merchant_id                  = 12334703

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
    parent.expect(:find_merchant_by_merchant_id, "this_merchant", [12334703])

    actual_merchants = test_item.merchant

    assert_equal "this_merchant", actual_merchants
    assert parent.verify
  end
end
