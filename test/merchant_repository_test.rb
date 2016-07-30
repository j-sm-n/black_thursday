require './test/test_helper'
require './lib/merchant_repository'
require './lib/loader'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :parent,
              :test_repository

  def setup
    path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @test_repository = MerchantRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    merchant_1_id = 12334141
    merchant_2_id = 12334105
    merchant_3_id = 11111111

    actual_merchant_1 = test_repository.find_by_id(merchant_1_id)
    actual_merchant_2 = test_repository.find_by_id(merchant_2_id)
    actual_merchant_3 = test_repository.find_by_id(merchant_3_id)

    actual_merchant_id_1 = actual_merchant_1.id unless actual_merchant_1.nil?
    actual_merchant_id_2 = actual_merchant_2.id unless actual_merchant_2.nil?
    actual_merchant_id_3 = actual_merchant_3.id unless actual_merchant_3.nil?

    assert_equal 3, test_repository.count
    assert_equal 12334141, actual_merchant_id_1
    assert_equal 12334105, actual_merchant_id_2
    assert_equal nil, actual_merchant_id_3
  end

  def test_it_can_find_all_by_name
    name_1 = "jejum"
    name_2 = "e"
    name_3 = "Jeff Casimir"

    actual_merchants_w_name_1 = test_repository.find_all_by_name(name_1)
    actual_merchants_w_name_2 = test_repository.find_all_by_name(name_2)
    actual_merchants_w_name_3 = test_repository.find_all_by_name(name_3)

    actual_merchants_w_name_1.map! { |item| item.id } unless actual_merchants_w_name_1.empty?
    actual_merchants_w_name_2.map! { |item| item.id } unless actual_merchants_w_name_2.empty?
    actual_merchants_w_name_3.map! { |item| item.id } unless actual_merchants_w_name_3.empty?

    assert_equal [12334141], actual_merchants_w_name_1
    assert_equal [12334141, 12337041], actual_merchants_w_name_2
    assert_equal [], actual_merchants_w_name_3
  end

  def test_it_finds_items_by_merchant_id
    parent.expect(:find_items_by_merchant, "this_merchant", [12334141])
    parent.expect(:find_items_by_merchant, nil, [11111111])

    actual_items_1 = test_repository.find_items_by_merchant(12334141)
    actual_items_2 = test_repository.find_items_by_merchant(11111111)
    assert parent.verify
  end

  def test_it_finds_invoices_by_merchant_id
    parent.expect(:find_invoices_by_merchant, "this_merchant", [12334141])
    parent.expect(:find_invoices_by_merchant, nil, [11111111])

    actual_invoices_1 = test_repository.find_invoices_by_merchant(12334141)
    actual_invoices_2 = test_repository.find_invoices_by_merchant(11111111)
    assert parent.verify
  end
end
