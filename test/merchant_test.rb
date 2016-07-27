require './test/test_helper'
require './lib/merchant'
require './lib/parser'
require './lib/sales_engine'

class MerchantTest < Minitest::Test
  attr_reader :test_merchant,
              :test_merchant_repository,
              :contents

  def setup
    @contents = Parser.new.load("./data/merchants_test.csv")
    sales_engine = SalesEngine.from_csv({:items => "./data/items_test.csv",
                                          :merchants => "./data/merchants_test.csv",})
    @test_merchant_repository = MerchantRepository.new(contents, sales_engine)
    @test_merchant = Merchant.new({:id => 5,
                       :name => "Turing School",
                       :created_at => "2010-12-10",
                       :updated_at => "2011-12-04"},
                       test_merchant_repository)
  end

  def test_it_exists
    assert_instance_of Merchant, test_merchant
  end

  def test_it_has_an_id
    assert_equal 5, test_merchant.id
  end

  def test_it_has_a_name
    assert_equal "Turing School", test_merchant.name
  end

  def test_it_has_a_parent
    assert_equal test_merchant_repository, test_merchant.parent
  end

  def test_it_has_all_the_properties_of_a_merchant
    date_1 = "2010-12-10"
    date_2 = "2011-12-04"

    assert_equal 5, test_merchant.id
    assert_equal "Turing School", test_merchant.name
    assert_equal Date.parse(date_1), test_merchant.created_at
    assert_equal Date.parse(date_2), test_merchant.updated_at
    assert_equal test_merchant_repository, test_merchant.parent
  end

end
