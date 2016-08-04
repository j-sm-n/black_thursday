require './test/test_helper'
require './lib/merchant_repository'
require './lib/repository'
require './lib/invoice_item_repository'

class RepositoryTest < Minitest::Test

  attr_reader :parent,
              :repo

  def setup
    path = "./test/fixtures/3_merchants.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @repo = MerchantRepository.new(contents, parent)
  end


  def test_it_has_a_count
    assert_equal 3, repo.count
  end

  def test_it_can_find_by_id
    id_1 = 12334141
    id_2 = 12334105
    id_3 = 11111111

    child_1 = repo.find_by_id(12334141)
    child_2 = repo.find_by_id(12334105)
    child_3 = repo.find_by_id(11111111)

    child_1_id = child_1.id unless child_1.nil?
    child_2_id = child_2.id unless child_2.nil?
    child_3_id = child_3.id unless child_3.nil?

    assert_equal id_1, child_1_id
    assert_equal id_2, child_2_id
    assert_equal nil, child_3_id
  end

  def test_it_can_find_by_name
    name_1 = "jejum"
    name_2 = "Shopin1901"
    name_3 = "Jeff Casimir"

    child_1 = repo.find_by_name(name_1)
    child_2 = repo.find_by_name(name_2)
    child_3 = repo.find_by_name(name_3)

    child_1_id = child_1.id unless child_1.nil?
    child_2_id = child_2.id unless child_2.nil?
    child_3_id = child_3.id unless child_3.nil?

    assert_equal 12334141, child_1_id
    assert_equal 12334105, child_2_id
    assert_equal nil, child_3_id
  end

  def test_it_can_return_all_child_items
    actual_ids = [12334141, 12334105, 12337041]
    invalid_id = [11111111]

    repository_children = repo.all

    assert_equal false, repository_children.empty?
    repository_children.each do |child|
      assert_equal true, actual_ids.include?(child.id)
      assert_equal false, invalid_id.include?(child.id)
    end
  end

  def test_it_can_return_children_that_contain_given_invoice_id
    file_path = "./test/fixtures/15_invoice_items.csv"
    parent = Minitest::Mock.new
    test_invoice_item_repository = InvoiceItemRepository.new
    test_invoice_item_repository.from_csv(file_path, parent)

    invoice_id = 100
    expected_id = [468, 469, 470]

    actual = test_invoice_item_repository.find_all_by_invoice_id(invoice_id)

    assert_equal 3, actual.length
    assert_equal InvoiceItem, actual.first.class
    actual.each do |invoice_item|
      assert_equal true, expected_id.include?(invoice_item.id)
    end
  end

end
