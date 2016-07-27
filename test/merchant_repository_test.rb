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

  # def test_it_has_a_count
  #   test_merchant_repository = MerchantRepository.new([],sales_engine)
  #   assert_equal 0, test_merchant_repository.count
  # end

  # def test_it_can_return_all_merchants
  #   contents = Parser.new.load("./data/merchants_test.csv")
  #   test_merchant_repository = MerchantRepository.new(contents, sales_engine)
  #
  #   merchants = test_merchant_repository.all
  #   assert_equal 9, merchants.length
  #   assert_instance_of Merchant, merchants[0]
  # end

  # def test_it_can_find_by_id
  #   contents = Parser.new.load("./data/merchants_test.csv")
  #   test_merchant_repository = MerchantRepository.new(contents, sales_engine)
  #   merchant_1 = Merchant.new({:id => "12334105",
  #                        :name => "Shopin1901",
  #                        :created_at => "2010-12-10",
  #                        :updated_at => "2011-12-04"},
  #                        test_merchant_repository)
  #   actual_merchant_1 = test_merchant_repository.find_by_id(12334105)
  #   actual_merchant_1_id = actual_merchant_1.id
  #
  #   assert_equal actual_merchant_1_id, merchant_1.id
  #
  #   actual_2 = test_merchant_repository.find_by_id(1606)
  #   expected_2 = nil
  #   assert_equal expected_2, actual_2
  # end

  # def test_it_can_find_by_name
  #   contents = Parser.new.load("./data/merchants_test.csv")
  #   test_merchant_repository = MerchantRepository.new(contents, sales_engine)
  #   merchant_1 = Merchant.new({:id => "12334105",
  #                        :name => "Shopin1901",
  #                        :created_at => "2010-12-10",
  #                        :updated_at => "2011-12-04"},
  #                        test_merchant_repository)
  #   actual_merchant_1 = test_merchant_repository.find_by_name("Shopin1901")
  #   actual_merchant_1_name = actual_merchant_1.name
  #   actual_2 = test_merchant_repository.find_by_name("TURING SCHOOL")
  #   expected_2 = nil
  #
  #   assert_equal actual_merchant_1_name, merchant_1.name
  #   assert_equal expected_2, actual_2
  # end

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
