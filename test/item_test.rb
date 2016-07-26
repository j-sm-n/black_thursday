require './test/test_helper'
require './lib/item'

class ItemTest < Minitest::Test
  attr_reader :i,
              :this_time_1,
              :this_time_2

  def setup
    @this_time_1 = Time.now
    @this_time_2 = Time.now
    @i = Item.new("263444697", "Pencil", "You can use it to write things", BigDecimal.new(10.99,4), this_time_1, this_time_2, "12334496")
  end

  def test_it_exists
    assert_instance_of Item, @i
  end

  def test_it_has_all_the_properties_of_an_item
    assert_equal "263444697", @i.id
    assert_equal "Pencil", @i.name
    assert_equal "You can use it to write things", @i.description
    assert_equal BigDecimal.new(10.99,4), @i.unit_price
    assert_equal this_time_1, @i.created_at
    assert_equal this_time_2, @i.updated_at
    assert_equal "12334496", @i.merchant_id
  end

  def test_it_can_return_unit_price_as_float
    assert_equal 10.99, @i.unit_price_to_dollars
  end

  # def test_it_has_an_id
  #   assert_equal "12334496", @m.id
  # end
  #
  # def test_it_has_a_name
  #   assert_equal "ElaineClausonArt", @m.name
  # end

end
