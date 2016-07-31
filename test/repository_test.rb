require './test/test_helper'
require './lib/loader'
require './lib/merchant_repository'
require './lib/repository'
require './lib/invoice_item_repository'

class RepositoryTest < Minitest::Test

  attr_reader :parent,
              :test_repository

  def setup
    path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @test_repository = MerchantRepository.new(contents, parent)
  end


  def test_it_has_a_count
    assert_equal 3, test_repository.count
  end

  def test_it_can_find_by_id
    id_1 = 12334141
    id_2 = 12334105
    id_3 = 11111111

    repository_child_1 = test_repository.find_by_id(12334141)
    repository_child_2 = test_repository.find_by_id(12334105)
    repository_child_3 = test_repository.find_by_id(11111111)

    repository_child_1_id = repository_child_1.id unless repository_child_1.nil?
    repository_child_2_id = repository_child_2.id unless repository_child_2.nil?
    repository_child_3_id = repository_child_3.id unless repository_child_3.nil?

    assert_equal id_1, repository_child_1_id
    assert_equal id_2, repository_child_2_id
    assert_equal nil, repository_child_3_id
  end

  def test_it_can_find_by_name
    name_1 = "jejum"
    name_2 = "Shopin1901"
    name_3 = "Jeff Casimir"

    repository_child_1 = test_repository.find_by_name(name_1)
    repository_child_2 = test_repository.find_by_name(name_2)
    repository_child_3 = test_repository.find_by_name(name_3)

    repository_child_1_id = repository_child_1.id unless repository_child_1.nil?
    repository_child_2_id = repository_child_2.id unless repository_child_2.nil?
    repository_child_3_id = repository_child_3.id unless repository_child_3.nil?

    assert_equal 12334141, repository_child_1_id
    assert_equal 12334105, repository_child_2_id
    assert_equal nil, repository_child_3_id
  end

  def test_it_can_return_all_merchants
    actual_ids = [12334141, 12334105, 12337041]
    invalid_id = [11111111]

    repository_children = test_repository.all

    assert_equal false, repository_children.empty?
    repository_children.each do |child|
      assert_equal true, actual_ids.include?(child.id)
      assert_equal false, invalid_id.include?(child.id)
    end
  end

  def test_it_can_return_item_invoices_that_contain_given_item_id
    file_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    parent = Minitest::Mock.new
    test_invoice_item_repository = InvoiceItemRepository.new
    test_invoice_item_repository.from_csv(file_path, parent)

    item_id = 263408101
    expected_id = [3356, 8193, 8362, 10215, 11894, 14898, 14982,
                  15035, 16392, 20508, 21456]

    actual = test_invoice_item_repository.find_all_by_item_id(item_id)

    assert_equal 11, actual.length
    assert_equal InvoiceItem, actual.first.class
    actual.each do |invoice_item|
      assert_equal true, expected_id.include?(invoice_item.id)
    end
  end
end
