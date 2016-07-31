require './test/test_helper'
require './lib/customer_repository'
require 'pry'

class CustomerRepositoryTest < Minitest::Test

  attr_reader :test_customer_repository,
              :parent

  def setup
    file_path = "./test/fixtures/customer_repository_fixture.csv"
    @parent = Minitest::Mock.new
    @test_customer_repository = CustomerRepository.new
    test_customer_repository.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    assert_equal 92, test_customer_repository.all.length
  end

  def test_invoice_item_repository_has_parent
    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", test_customer_repository.parent.class
    assert parent.verify
  end

  def test_it_can_find_all_by_first_name
    first_name_1 = "oe"
    first_name_2 = "oE"

    actual_1 = test_customer_repository.find_all_by_first_name(first_name_1)
    actual_2 = test_customer_repository.find_all_by_first_name(first_name_2)

    assert_equal 8, actual_1.length
    actual_1.each { |customer| assert_equal Customer, customer.class }
    actual_1.each do |customer|
      assert_equal true, customer.first_name_downcase.include?(first_name_1.downcase)
    end

    assert_equal 8, actual_2.length
    actual_2.each { |customer| assert_equal Customer, customer.class }
    actual_2.each do |customer|
      assert_equal true, customer.first_name_downcase.include?(first_name_2.downcase)
    end
  end

  def test_it_can_find_all_by_last_name
    last_name_1 = "On"
    last_name_2 = "oN"

    actual_1 = test_customer_repository.find_all_by_last_name(last_name_1)
    actual_2 = test_customer_repository.find_all_by_last_name(last_name_2)

    assert_equal 85, actual_1.length
    actual_1.each { |customer| assert_equal Customer, customer.class }
    actual_1.each do |customer|
      assert_equal true, customer.last_name_downcase.include?(last_name_1.downcase)
    end

    assert_equal 85, actual_2.length
    actual_2.each { |customer| assert_equal Customer, customer.class }
    actual_2.each do |customer|
      assert_equal true, customer.last_name_downcase.include?(last_name_2.downcase)
    end
  end
end
