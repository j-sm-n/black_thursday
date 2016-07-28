require './test/test_helper'
require './lib/item'
require './lib/parser'
require './lib/sales_engine'

class ItemTest < Minitest::Test
  attr_reader :test_item,
              :test_item_repository,
              :test_time_1,
              :test_time_2

  def setup
    contents = Parser.new.load("./data/items_test.csv")
    sales_engine = SalesEngine.from_csv({
                           :items     => "./data/items_test.csv",
                           :merchants => "./data/merchants_test.csv",
                         })
    @test_time_1 = "2016-01-11 18:07:30 UTC"
    @test_time_2 = "2012-03-27 14:54:33 UTC"
    @test_item_repository = ItemRepository.new(contents, sales_engine)
    @test_item = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => "1099",
      :created_at  => test_time_1,
      :updated_at  => test_time_2,
      :id => "263444697",
      :merchant_id => "12334496"
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
    assert_equal Time.parse(test_time_1), test_item.created_at
    assert_equal Time.parse(test_time_2), test_item.updated_at
    assert_equal 12334496, test_item.merchant_id
  end

  def test_it_can_return_unit_price_as_float
    assert_equal 10.99, test_item.unit_price_to_dollars
  end

  def test_item_has_parent
    assert_equal test_item_repository, test_item.parent
  end

  def test_item_returns_merchant_it_is_sold_by
    sales_engine = SalesEngine.from_csv({
               :items     => "./data/items_test.csv",
               :merchants => "./data/merchants_test.csv",
             })
    item_repo = sales_engine.items
    item = item_repo.find_by_id(263440155)

    assert_equal "Iron Man Perler Bead Magnet/ Ornament", item.merchant.name
  end
end
