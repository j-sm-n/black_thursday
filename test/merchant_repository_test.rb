require './test/test_helper'
require './lib/merchant_repository'
require './lib/parser'
require './lib/sales_engine'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({:items => "./data/items_test.csv",
                                         :merchants => "./data/merchants_test.csv",})
  end
  def test_it_exists
    test_merchant_repository = MerchantRepository.new([],sales_engine)
    assert_instance_of MerchantRepository, test_merchant_repository
  end

  def test_it_can_find_all_by_name
    contents = Parser.new.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    actual = test_merchant_repository.find_all_by_name("e")
    expected_names = ["MiniatureBikez", "LolaMarleys", "Keckenbauer", "perlesemoi", "GoldenRayPress", "jejum", "Urcase17"]
    actual.each do |merchant|
      assert_equal true, expected_names.include?(merchant.name)
    end
    assert_equal expected_names.length, actual.length
  end

  def test_it_can_populate_itself_with_child_merchants
    test_merchant_repository = MerchantRepository.new([], sales_engine)
    contents = Parser.new.load("./data/merchants_test.csv")
    actual = test_merchant_repository.populate(contents)
    assert_equal 9, actual.length
  end

  def test_initialization_populates_the_repository
    contents = Parser.new.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    assert_equal 9, test_merchant_repository.all.length
    refute_equal 0, test_merchant_repository.count
  end
end
