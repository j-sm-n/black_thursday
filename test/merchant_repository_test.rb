require './test/test_helper'
require './lib/merchant_repository'
require './lib/merchant'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :mr,
              :merchant_1,
              :merchant_2

  def setup
    @mr = MerchantRepository.new
    @merchant_1 = Merchant.new({:id => 5, :name => "Turing School"})
    @merchant_2 = Merchant.new({:id => 12334145, :name => "BowlsByChris"})
  end

  def test_it_exists
    assert_instance_of MerchantRepository, mr
  end

  def test_it_has_a_count
    assert_equal 0, mr.count
  end

  def test_it_can_add_merchants
    mr << merchant_1
    actual_1 = mr.count
    mr << merchant_2
    actual_2 = mr.count

    assert_equal 1, actual_1
    assert_equal 2, actual_2
  end

  def test_it_can_return_all_merchants
    expected_1 = []
    actual_1 = mr.all
    assert_equal expected_1, actual_1

    mr << merchant_1
    mr << merchant_2
    expected_2 = [merchant_1, merchant_2]
    actual_2 = mr.all
    assert_equal expected_2, actual_2
  end

  def test_it_can_find_by_id
    mr << merchant_1
    mr << merchant_2
    actual_1 = mr.find_by_id(5)
    actual_2 = mr.find_by_id(12334145)
    actual_3 = mr.find_by_id(1606)
    expected_1 = merchant_1
    expected_2 = merchant_2
    expected_3 = nil

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
  end

end
