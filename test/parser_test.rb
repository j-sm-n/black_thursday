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

  def test_it_parses_merchant_data
    file_name = "./data/merchants_test.csv"
    expected = ""

    actual = p.parse_merchant_csv(file_name)

    assert_equal expected, actual
  end

end


# id,name,created_at,updated_at
# 12334496,ElaineClausonArt,12/9/2001,10/17/2007
