require './test/test_helper'
require './lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test

  attr_reader :customer_repo,
              :parent

  def setup
    file_path = "./test/fixtures/customer_repository_fixture.csv"
    @parent = Minitest::Mock.new
    @customer_repo = CustomerRepository.new
    customer_repo.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    assert_equal 92, customer_repo.all.length
  end

  def test_invoice_item_repository_has_parent
    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", customer_repo.parent.class
    assert parent.verify
  end

  def test_it_can_find_all_by_first_name
    first_name_1 = "oe"
    first_name_2 = "oE"

    actual_1 = customer_repo.find_all_by_first_name(first_name_1)
    actual_2 = customer_repo.find_all_by_first_name(first_name_2)

    assert_equal 8, actual_1.length
    actual_1.each { |customer| assert_equal Customer, customer.class }
    actual_1.each do |customer|
      actual = customer.first_name_downcase.include?(first_name_1.downcase)
      assert_equal true, actual
    end

    assert_equal 8, actual_2.length
    actual_2.each { |customer| assert_equal Customer, customer.class }
    actual_2.each do |customer|
      actual = customer.first_name_downcase.include?(first_name_2.downcase)
      assert_equal true, actual
    end
  end

  def test_it_can_find_all_by_last_name
    last_name_1 = "On"
    last_name_2 = "oN"

    actual_1 = customer_repo.find_all_by_last_name(last_name_1)
    actual_2 = customer_repo.find_all_by_last_name(last_name_2)

    assert_equal 85, actual_1.length
    actual_1.each { |customer| assert_equal Customer, customer.class }
    actual_1.each do |customer|
      actual = customer.last_name_downcase.include?(last_name_1.downcase)
      assert_equal true, actual
    end

    assert_equal 85, actual_2.length
    actual_2.each { |customer| assert_equal Customer, customer.class }
    actual_2.each do |customer|
      actual = customer.last_name_downcase.include?(last_name_2.downcase)
      assert_equal true, actual
    end
  end
end
