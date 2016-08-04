require './test/test_helper'
require './lib/invoice_item'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/1_invoice_item.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @invoice_item = InvoiceItem.new(data, parent)
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

    assert_equal expected_id, invoice_item.id
    assert_equal expected_item_id, invoice_item.item_id
    assert_equal expected_invoice_id, invoice_item.invoice_id
    assert_equal expected_quantity, invoice_item.quantity
    assert_equal expected_unit_price, invoice_item.unit_price
    assert_equal expected_created_at, invoice_item.created_at
    assert_equal expected_updated_at, invoice_item.updated_at
  end

  def test_invoice_item_has_parent
    parent.expect(:class, "InvoiceRepository")
    assert_equal "InvoiceRepository", invoice_item.parent.class
    assert parent.verify
  end

  def test_returns_the_price_of_invoice_item_in_dollars_as_float
    assert_equal 136.35, invoice_item.unit_price_to_dollars
  end

  def test_it_knows_its_total_price
    assert_equal 136.35 * 4, invoice_item.price
  end
end
