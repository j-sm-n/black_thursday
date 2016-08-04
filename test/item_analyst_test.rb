require './test/test_helper'
require './lib/sales_analyst'

class ItemAnalystTest < Minitest::Test
  attr_reader :analyst

  def setup
    item_path = "./test/fixtures/20_items.csv"

    engine = SalesEngine.from_csv({:items => item_path})
    @analyst = SalesAnalyst.new(engine)
  end


  def test_it_knows_golden_items
    expected_golden_item_ids = [263426247, 263426657]

    actual_golden_items = analyst.golden_items
    assert_equal false, actual_golden_items.nil?

    actual_golden_item_ids = actual_golden_items.map { |item| item.id }

    assert_equal expected_golden_item_ids, actual_golden_item_ids
  end

  def test_it_finds_most_sold_items
    assert_respond_to(analyst, :most_sold_item_for_merchant)
  end

  def test_it_finds_best_item
    assert_respond_to(analyst, :best_item_for_merchant)
  end

end
