require './test/test_helper'
require './lib/loader'
require './lib/invoice_item'

class InvoiceItemTest < Minitest::Test
  attr_reader :test_invoice_item,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/invoice_item_fixture.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_invoice_item = InvoiceItem.new(data, parent)
    end
  end

  def test_it_has_all_the_properties_of_an_invoice_item
    expected_id          = 21830
    expected_item_id     = 263519844
    expected_invoice_id  = 4985
    expected_quantity    = 4
    expected_unit_price  = BigDecimal.new("136.35")
    expected_created_at  = Time.parse("2014-02-13")
    expected_updated_at  = Time.parse("2016-01-06")

    assert_equal expected_id, test_invoice_item.id
    assert_equal expected_item_id, test_invoice_item.item_id
    assert_equal expected_invoice_id, test_invoice_item.invoice_id
    assert_equal expected_quantity, test_invoice_item.quantity
    assert_equal expected_unit_price, test_invoice_item.unit_price
    assert_equal expected_created_at, test_invoice_item.created_at
    assert_equal expected_updated_at, test_invoice_item.updated_at
  end

  def test_invoice_item_has_parent
    parent.expect(:class, "InvoiceRepository")
    assert_equal "InvoiceRepository", test_invoice_item.parent.class
    assert parent.verify
  end

  def test_returns_the_price_of_invoice_item_in_dollars_as_float
    assert_equal 136.35, test_invoice_item.unit_price_to_dollars
  end

  def test_it_knows_its_total_price
    assert_equal 136.35 * 4, test_invoice_item.price
  end
end
