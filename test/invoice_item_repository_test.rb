require './test/test_helper'
require './lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :invoice_item_repo,
              :parent

  def setup
    file_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    @parent = Minitest::Mock.new
    @invoice_item_repo = InvoiceItemRepository.new
    invoice_item_repo.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    assert_equal 15, invoice_item_repo.all.length
  end

  def test_invoice_item_repository_has_parent
    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", invoice_item_repo.parent.class
    assert parent.verify
  end

  def test_it_can_return_item_invoices_that_contain_given_item_id
    item_id = 263408101
    expected_id = [3356, 8193, 8362, 10215, 11894, 14898, 14982,
                  15035, 16392, 20508, 21456]

    actual = invoice_item_repo.find_all_by_item_id(item_id)

    assert_equal 11, actual.length
    assert_equal InvoiceItem, actual.first.class
    actual.each do |invoice_item|
      assert_equal true, expected_id.include?(invoice_item.id)
    end
  end

end
