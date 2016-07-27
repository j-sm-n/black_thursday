require './test/test_helper'
require './lib/merchant'
require './lib/parser'

class MerchantTest < Minitest::Test
  attr_reader :test_merchant,
              :test_merchant_repository,
              :contents

  def setup
    @contents = Parser.new.load("./data/merchants_test.csv")
    @test_merchant_repository = MerchantRepository.new(contents)
    @test_merchant = Merchant.new({:id => 5,
                       :name => "Turing School",
                       :created_at => Time.now - (60 * 60),
                       :updated_at => Time.now},
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

  def test_it_has_a_repository
    assert_equal test_merchant_repository, test_merchant.repository
  end

end
