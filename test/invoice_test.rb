require './test/test_helper'
require './lib/loader'
require './lib/invoice'

class InvoiceTest < Minitest::Test
  attr_reader :test_invoice,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/invoice_fixture.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_invoice = Invoice.new(data, parent)
    end
  end

  def test_it_has_all_the_properties_of_an_item
    expected_id                           = 181
    expected_customer_id                  = 35
    expected_status                       = :returned
    expected_created_at                   = Date.parse("2013-08-20")
    expected_updated_at                   = Date.parse("2015-04-01")
    expected_merchant_id                  = 12334420

    assert_equal expected_id, test_invoice.id
    assert_equal expected_customer_id, test_invoice.customer_id
    assert_equal expected_status, test_invoice.status
    assert_equal expected_created_at, test_invoice.created_at
    assert_equal expected_updated_at, test_invoice.updated_at
    assert_equal expected_merchant_id, test_invoice.merchant_id
  end

  def test_item_has_parent
    parent.expect(:class, InvoiceRepository)
    assert_equal InvoiceRepository, test_invoice.parent.class
    assert parent.verify
  end

end
