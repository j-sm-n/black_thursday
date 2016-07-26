require './test/test_helper'
require './lib/item'

class ItemTest < Minitest::Test
  attr_reader :i,
              :ir,
              :this_time_1,
              :this_time_2

  def setup
    @this_time_1 = Time.now - (60 * 60)
    @this_time_2 = Time.now
    @i = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => BigDecimal.new(10.99,4),
      :created_at  => this_time_1,
      :updated_at  => this_time_2,
      :id => 263444697,
      :merchant_id => 12334496
    })
    @ir = ItemRepository.new
  end

  def test_it_exists
    assert_instance_of Item, @i
  end

  def test_it_has_all_the_properties_of_an_item
    assert_equal 263444697, @i.id
    assert_equal "Pencil", @i.name
    assert_equal "You can use it to write things", @i.description
    assert_equal BigDecimal.new(10.99,4), @i.unit_price
    assert_equal this_time_1, @i.created_at
    assert_equal this_time_2, @i.updated_at
    assert_equal 12334496, @i.merchant_id
  end

  def test_it_can_return_unit_price_as_float
    assert_equal 10.99, @i.unit_price_to_dollars
  end

  def test_item_has_parent
    i.set_parent(ir)

    assert_equal ir, i.parent
  end
end
