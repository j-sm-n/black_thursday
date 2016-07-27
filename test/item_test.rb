require './test/test_helper'
require './lib/item'
require './lib/parser'

class ItemTest < Minitest::Test
  attr_reader :test_item,
              :test_item_repository,
              :this_time_1,
              :this_time_2

  def setup
    contents = Parser.new.load("./data/items_test.csv")
    @this_time_1 = Time.now - (60 * 60)
    @this_time_2 = Time.now
    @test_item_repository = ItemRepository.new(contents)
    @test_item = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => 1099,
      :created_at  => this_time_1,
      :updated_at  => this_time_2,
      :id => 263444697,
      :merchant_id => 12334496
    }, test_item_repository)
  end

  def test_it_exists
    assert_instance_of Item, test_item
  end

  def test_it_has_all_the_properties_of_an_item
    assert_equal 263444697, test_item.id
    assert_equal "Pencil", test_item.name
    assert_equal "You can use it to write things", test_item.description
    assert_equal BigDecimal.new("1099")/100, test_item.unit_price
    assert_equal this_time_1, test_item.created_at
    assert_equal this_time_2, test_item.updated_at
    assert_equal 12334496, test_item.merchant_id
  end

  def test_it_can_return_unit_price_as_float
    assert_equal 10.99, test_item.unit_price_to_dollars
  end

  def test_item_has_parent
    assert_equal test_item_repository, test_item.repository
  end

  def test_time_states_are_scrubbed
    skip
    item.created_at == date_scrubber(data[:created_at])
  end
end
