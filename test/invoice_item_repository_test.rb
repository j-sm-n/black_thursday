require './test/test_helper'
require './lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :test_invoice_item_repository,
              :parent

  def setup
    file_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    @parent = Minitest::Mock.new
    @test_invoice_item_repository = InvoiceItemRepository.new
    test_invoice_item_repository.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    assert_equal 15, test_invoice_item_repository.all.length
  end

  def test_invoice_item_repository_has_parent
    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", test_invoice_item_repository.parent.class
    assert parent.verify
  end

  def test_it_can_return_item_invoices_that_contain_given_invoice_id
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
