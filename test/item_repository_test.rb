require './test/test_helper'
require './lib/item_repository'
require './lib/parser'

class ItemRepositoryTest < Minitest::Test
  attr_reader :test_empty_item_repository,
              :test_item_repository,
              :contents,
              :item_1,
              :item_2,
              :item_3,
              :item_4,
              :item_5

  def setup
    @contents = Parser.new.load("./data/items_test.csv")
    @test_empty_item_repository = ItemRepository.new(contents)
    @test_item_repository = ItemRepository.new(contents)
    @item_1 = Item.new({
      :name => "Rose gold brooch, flower brooch, pearl brooch, \
               blue brooch, bulk brooch, wholesale brooches sale \
               20 brooches",
      :description => "size :1.0&quot;-3.0&quot; quantity: 20 pcs\
                       Color: blue, gold plated and red NOTE: These\
                       are samples. It does not guarantee to receive \
                       any or all of the brooches as shown Quality \
                       is guaranteed. Thank you for shopping!",
      :unit_price => 11770,
      :created_at => Date.new(1975,11,07,16),
      :updated_at => Date.new(2016,01,11,18),
      :id => 263444697,
      :merchant_id => 12336081
      }, test_item_repository)
    @item_2 = Item.new({
      :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => 1099,
      :created_at => Time.now - (60 * 60),
      :updated_at => Time.now,
      :id => 1234,
      :merchant_id => 78910
      }, test_item_repository)
    @item_3 = Item.new({
      :name => "Eraser",
      :description => "You can use it to erase things",
      :unit_price => 199,
      :created_at => Time.now - (60 * 60),
      :updated_at => Time.now,
      :id => 2341,
      :merchant_id => 78910
      }, test_item_repository)
    @item_4 = Item.new({
      :name => "Color Markers",
      :description => "You can use it to write things in color",
      :unit_price => 1199,
      :created_at => Time.now - (60 * 60),
      :updated_at => Time.now,
      :id => 9870,
      :merchant_id => 78910
      }, test_item_repository)
    @item_5 = Item.new({
      :name => "Permanent Markers",
      :description => "You can use it to write things forever",
      :unit_price => 1199,
      :created_at => Time.now - (60 * 60),
      :updated_at => Time.now,
      :id => 9871,
      :merchant_id => 78910
      }, test_item_repository)

      [item_1, item_2, item_3, item_4, item_5].each { |item| test_item_repository << item }
    end

  def test_it_exists
    assert_instance_of ItemRepository, test_empty_item_repository
  end

  def test_it_has_a_count
    assert_equal 0, test_empty_item_repository.count
  end

  def test_it_can_add_items
    test_empty_item_repository << item_1
    actual_1 = test_empty_item_repository.count
    test_empty_item_repository << item_2
    actual_2 = test_empty_item_repository.count

    assert_equal 1, actual_1
    assert_equal 2, actual_2
  end

  def test_it_can_return_all_items
    expected_1 = []
    actual_1 = test_empty_item_repository.all

    assert_equal expected_1, actual_1

    expected_2 = [item_1, item_2, item_3, item_4, item_5]
    actual_2 = test_item_repository.all

    assert_equal expected_2, actual_2
  end

  def test_it_can_find_by_id
    [item_1, item_2, item_3, item_4, item_5].each { |item| test_item_repository << item }
    expected_1 = item_1
    expected_2 = item_2
    expected_3 = nil

    actual_1 = test_item_repository.find_by_id(263444697)
    actual_2 = test_item_repository.find_by_id(1234)
    actual_3 = test_item_repository.find_by_id(000000000)

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
  end

  def test_it_can_find_by_name
    expected_1 = item_2
    expected_2 = nil

    actual_1 = test_item_repository.find_by_name("PENCIL")
    actual_2 = test_item_repository.find_by_name("Turing Machine")

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
  end

  def test_it_can_find_all_with_description
    expected_1 = [item_2, item_4, item_5]
    expected_2 = [item_1]
    expected_3 = [item_1, item_2, item_3, item_4, item_5]
    expected_4 = []

    actual_1 = test_item_repository.find_all_with_description("WRITE")
    actual_2 = test_item_repository.find_all_with_description("gold PLATED")
    actual_3 = test_item_repository.find_all_with_description("e")
    actual_4 = test_item_repository.find_all_with_description("super")

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
    assert_equal expected_4, actual_4
  end

  def test_it_can_find_all_by_price
    expected_1 = [item_2]
    expected_2 = [item_4, item_5]
    expected_3 = []

    actual_1 = test_item_repository.find_all_by_price(1099)
    actual_2 = test_item_repository.find_all_by_price(1199)
    actual_3 = test_item_repository.find_all_by_price(2501)

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
  end

  def test_it_can_find_all_in_price_range
    expected_1 = [item_2, item_4, item_5]
    expected_2 = [item_1]
    expected_3 = [item_1, item_2, item_3, item_4, item_5]
    expected_4 = []
    range_1 = Range.new(1000, 1199)
    range_2 = Range.new(11770, 11771)
    range_3 = Range.new(0, 11771)
    range_4 = Range.new(0, 1)

    actual_1 = test_item_repository.find_all_by_price_in_range(range_1)
    actual_2 = test_item_repository.find_all_by_price_in_range(range_2)
    actual_3 = test_item_repository.find_all_by_price_in_range(range_3)
    actual_4 = test_item_repository.find_all_by_price_in_range(range_4)

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
    assert_equal expected_4, actual_4
  end

  def test_it_can_find_all_by_merchant_id
    expected_1 = [item_1]
    expected_2 = [item_2, item_3, item_4, item_5]
    expected_3 = []

    actual_1 = test_item_repository.find_all_by_merchant_id(12336081)
    actual_2 = test_item_repository.find_all_by_merchant_id(78910)

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
  end

  def test_it_can_populate_itself_with_child_merchants
    test_item_repository.populate(contents)

    assert_instance_of Item, test_item_repository.find_by_id(263435825)
    assert_instance_of Item, test_item_repository.items[0]
    assert_equal 15, test_item_repository.all.length
  end

  def test_items_repo_contains_items_with_parent_repo_named
    test_item_repository.populate(contents)

    assert_instance_of ItemRepository, test_item_repository.items[0].repository
  end
end
