require './test/test_helper'
require './lib/customer'

class CustomerTest < Minitest::Test
  attr_reader :customer,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/customer_fixture.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @customer = Customer.new(data, parent)
    end
  end

  def test_it_has_all_the_properties_of_a_customer
    expected_id = 1000
    expected_first_name = "Shawn"
    expected_last_name = "Langworth"
    expected_first_name_downcase = "shawn"
    expected_last_name_downcase = "langworth"
    expected_created_at  = Time.parse("2012-03-27 14:58:15 UTC")
    expected_updated_at  = Time.parse("2012-03-27 14:58:15 UTC")

    assert_equal expected_id, customer.id
    assert_equal expected_first_name, customer.first_name
    assert_equal expected_last_name, customer.last_name
    assert_equal expected_first_name_downcase, customer.first_name_downcase
    assert_equal expected_last_name_downcase, customer.last_name_downcase
    assert_equal expected_created_at, customer.created_at
    assert_equal expected_updated_at, customer.updated_at
  end

  def test_invoice_item_has_parent
    parent.expect(:class, "CustomerRepository")
    assert_equal "CustomerRepository", customer.parent.class
    assert parent.verify
  end

end
