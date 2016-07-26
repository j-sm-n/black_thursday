require './test/test_helper'
require './lib/parser'

class ParserTest < Minitest::Test
  attr_reader :p

  def setup
    @p = Parser.new
  end

  def test_it_exists
    assert_instance_of Parser, Parser.new
  end

  def test_it_loads_csv_by_line
    file_name = "./data/merchants_test.csv"
    actual = p.load(file_name)
    assert_instance_of CSV, actual
  end

  def test_it_parses_item_data
    file_name = "./data/items_test.csv"
    expected = 10

    actual = p.parse_items_csv(file_name).count
    assert_equal expected, actual

    assert_instance_of ItemRepository, p.parse_items_csv(file_name)
  end

end
