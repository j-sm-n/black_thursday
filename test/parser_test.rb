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

end
