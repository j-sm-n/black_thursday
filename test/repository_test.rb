require './test/test_helper'
require './lib/sales_engine'
require './lib/merchant_repository'
require './lib/repository'

class RepositoryTest < Minitest::Test

  attr_reader :sales_engine

  def setup
    @sales_engine = SalesEngine.from_csv({:items => "./data/items_test.csv",
                                         :merchants => "./data/merchants_test.csv",})
  end

  def test_it_has_a_count
    test_merchant_repository = MerchantRepository.new([],sales_engine)
    assert_equal 0, test_merchant_repository.count
  end

  def test_it_can_find_by_id
    contents = Loader.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    merchant_1 = Merchant.new({:id => "12334105",
                         :name => "Shopin1901",
                         :created_at => "2010-12-10",
                         :updated_at => "2011-12-04"},
                         test_merchant_repository)
    actual_merchant_1 = test_merchant_repository.find_by_id(12334105)
    actual_merchant_1_id = actual_merchant_1.id

    assert_equal actual_merchant_1_id, merchant_1.id

    actual_2 = test_merchant_repository.find_by_id(1606)
    expected_2 = nil
    assert_equal expected_2, actual_2
  end

  def test_it_can_find_by_name
    contents = Loader.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    merchant_1 = Merchant.new({:id => "12334105",
                         :name => "Shopin1901",
                         :created_at => "2010-12-10",
                         :updated_at => "2011-12-04"},
                         test_merchant_repository)
    actual_merchant_1 = test_merchant_repository.find_by_name("Shopin1901")
    actual_merchant_1_name = actual_merchant_1.name
    actual_2 = test_merchant_repository.find_by_name("TURING SCHOOL")
    expected_2 = nil

    assert_equal actual_merchant_1_name, merchant_1.name
    assert_equal expected_2, actual_2
  end

  def test_it_can_return_all_merchants
    contents = Loader.load("./data/merchants_test.csv")
    test_merchant_repository = MerchantRepository.new(contents, sales_engine)

    merchants = test_merchant_repository.all
    assert_equal 9, merchants.length
    assert_instance_of Merchant, merchants[0]
  end

end
