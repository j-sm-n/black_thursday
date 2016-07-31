require './test/test_helper'
require './lib/invoice_item_repository'

class InvoiceItemTest < Minitest::Test
  attr_reader :test_invoice_item_repository,
              :parent

  def setup
    file_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    @parent = Minitest::Mock.new
    @test_invoice_item_repository = InvoiceItemRepository.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    empty_invoice_item_repository = InvoiceItemRepository.new
    assert_equal nil, test_invoice_item_repository.repository

    test_invoice_item_repository.from_csv("./test/fixtures/invoice_item_repository_fixture.csv")
    assert_equal 15, test_invoice_item_repository.all.length
  end

  def test_invoice_item_repository_has_parent

    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", test_invoice_item_repository.parent.class
    assert parent.verify
  end

end

  #
  #
  #
  # ir = InvoiceItemRepository.new
  # ir.from_csv("./data/invoice_items.csv")
  # invoice = ir.find_by_id(6)
  # # => <invoice_item>
