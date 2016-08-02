require './test/test_helper'
require './lib/merchant_repository'
require './lib/merchant'
require './lib/loader'

class MerchantTest < Minitest::Test
  attr_reader :test_merchant,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/merchant.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_merchant = Merchant.new(data, parent)
    end
  end

  def test_it_exists
    assert_instance_of Merchant, test_merchant
  end

  def test_it_has_an_id
    assert_equal 12334407, test_merchant.id
  end

  def test_it_has_a_name
    assert_equal "MisisJuliBebe", test_merchant.name
  end

  def test_it_has_a_parent
    parent.expect(:class, MerchantRepository)
    assert_equal MerchantRepository, test_merchant.parent.class
    assert parent.verify
  end

  def test_it_has_all_the_properties_of_a_merchant
    date_1 = "2010-01-11"
    date_2 = "2011-09-24"

    assert_equal 12334407, test_merchant.id
    assert_equal "MisisJuliBebe", test_merchant.name
    assert_equal "MisisJuliBebe".downcase, test_merchant.case_insensitive_name
    assert_equal Date.parse(date_1), test_merchant.created_at
    assert_equal Date.parse(date_2), test_merchant.updated_at
    parent.expect(:class, MerchantRepository)
    assert_equal MerchantRepository, test_merchant.parent.class
    assert parent.verify
  end

  def test_it_finds_items_by_merchant_id
    invalid_merchant = Merchant.new({
      id: 1,
      created_at:"2010-01-11",
      updated_at:"2011-09-24",
      name:"invalid_merchant"}, parent)

    parent.expect(:find_items_by_merchant, "this_merchants_items", [12334407])
    parent.expect(:find_items_by_merchant, nil, [1])

    actual_items = test_merchant.items
    assert_equal "this_merchants_items", actual_items
    assert_equal nil, invalid_merchant.items
    assert parent.verify
  end

  def test_it_finds_invoices_by_merchant_id
    invalid_merchant = Merchant.new({
      id: 1,
      created_at:"2010-01-11",
      updated_at:"2011-09-24",
      name:"invalid_merchant"}, parent)

    parent.expect(:find_invoices_by_merchant, "this_merchants_invoices", [12334407])
    parent.expect(:find_invoices_by_merchant, nil, [1])
    actual_invoices = test_merchant.invoices
    assert_equal "this_merchants_invoices", actual_invoices
    assert_equal nil, invalid_merchant.invoices
    assert parent.verify
  end

  def test_it_knows_all_the_customers_of_a_merchant
    parent.expect(:find_customers_of_merchant, "customer", [12334407])

    actual_customer = test_merchant.customers

    assert_equal "customer", actual_customer
    assert parent.verify
  end

  def test_it_knows_its_revenue
    invoices_array = Minitest::Mock.new
    invoice = Minitest::Mock.new
    parent.expect(:find_invoices_by_merchant, invoices_array, [12334407])
    invoices_array.expect(:map, invoice)
    invoice.expect(:total, 1000000)
    invoice.expect(:reduce, 1000001, [:+])

    assert_equal 1000001, test_merchant.revenue
    assert parent.verify
  end

end
