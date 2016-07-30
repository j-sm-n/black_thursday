require './test/test_helper'
require './lib/invoice_repository'
require './lib/loader'
require 'pry'

class InvoiceRepositoryTest < Minitest::Test
  attr_reader :parent,
              :test_invoice_repository
  def setup
    path = "./test/fixtures/invoice_repository_fixture.csv"
    contents = Loader.load(path)
    @parent = Minitest::Mock.new
    @test_invoice_repository = InvoiceRepository.new(contents, parent)
  end

  def test_initialization_populates_the_repository
    assert_equal 10, test_invoice_repository.all.length
  end

  def test_it_can_find_all_by_customer_id
    customer_id_1 = 389
    customer_id_2 = 66
    customer_id_3 = 00

    actual_invoices_w_customer_id_1 = test_invoice_repository.find_all_by_customer_id(customer_id_1)
    actual_invoices_w_customer_id_2 = test_invoice_repository.find_all_by_customer_id(customer_id_2)
    actual_invoices_w_customer_id_3 = test_invoice_repository.find_all_by_customer_id(customer_id_3)

    actual_invoices_w_customer_id_1.map! { |invoice| invoice.id } unless actual_invoices_w_customer_id_1.empty?
    actual_invoices_w_customer_id_2.map! { |invoice| invoice.id } unless actual_invoices_w_customer_id_2.empty?
    actual_invoices_w_customer_id_3.map! { |invoice| invoice.id } unless actual_invoices_w_customer_id_3.empty?
    
    assert_equal [1963], actual_invoices_w_customer_id_1
    assert_equal [328], actual_invoices_w_customer_id_2
    assert_equal [], actual_invoices_w_customer_id_3
  end

end
