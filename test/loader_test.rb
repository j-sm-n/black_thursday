require './test/test_helper'
require './lib/loader'

class LoaderTest < Minitest::Test

  def test_it_exists
    assert_instance_of Loader, Loader.new
  end

  def test_it_loads_csv_by_line
    file_name = "./data/merchants_test.csv"
    actual = Loader.load(file_name)
    assert_instance_of CSV, actual
  end

end
