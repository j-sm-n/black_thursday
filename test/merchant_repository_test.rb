require './test/test_helper'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :parent,
              :merchant_repo

  def setup
    path = "./test/fixtures/3_merchants.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @merchant_repo = MerchantRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    id_1 = 12334141
    id_2 = 12334105
    id_3 = 11111111

    actual_1 = merchant_repo.find_by_id(id_1)
    actual_2 = merchant_repo.find_by_id(id_2)
    actual_3 = merchant_repo.find_by_id(id_3)

    actual_merchant_id_1 = actual_1.id unless actual_1.nil?
    actual_merchant_id_2 = actual_2.id unless actual_2.nil?
    actual_merchant_id_3 = actual_3.id unless actual_3.nil?

    assert_equal 3, merchant_repo.count
    assert_equal 12334141, actual_merchant_id_1
    assert_equal 12334105, actual_merchant_id_2
    assert_equal nil, actual_merchant_id_3
  end

  def test_it_can_find_all_by_name
    name_1 = "jejum"
    name_2 = "e"
    name_3 = "Jeff Casimir"

    actual_1 = merchant_repo.find_all_by_name(name_1)
    actual_2 = merchant_repo.find_all_by_name(name_2)
    actual_3 = merchant_repo.find_all_by_name(name_3)

    actual_1.map! { |item| item.id } unless actual_1.empty?
    actual_2.map! { |item| item.id } unless actual_2.empty?
    actual_3.map! { |item| item.id } unless actual_3.empty?

    assert_equal [12334141], actual_1
    assert_equal [12334141, 12337041], actual_2
    assert_equal [], actual_3
  end

  def test_it_finds_items_by_merchant_id
    parent.expect(:find_items_by_merchant, "this_merchant", [12334141])
    parent.expect(:find_items_by_merchant, nil, [11111111])

    actual_items_1 = merchant_repo.find_items_by_merchant(12334141)
    actual_items_2 = merchant_repo.find_items_by_merchant(11111111)
    assert parent.verify
  end

  def test_it_finds_invoices_by_merchant_id
    parent.expect(:find_invoices_by_merchant, "this_merchant", [12334141])
    parent.expect(:find_invoices_by_merchant, nil, [11111111])

    actual_invoices_1 = merchant_repo.find_invoices_by_merchant(12334141)
    actual_invoices_2 = merchant_repo.find_invoices_by_merchant(11111111)
    assert parent.verify
  end

  def test_it_can_find_customers_of_merchant
    expected = "customers"
    parent.expect(:find_customers_of_merchant, expected, ["merchant"])

    actual = merchant_repo.find_customers_of_merchant("merchant")

    assert_equal expected, actual
  end
end
