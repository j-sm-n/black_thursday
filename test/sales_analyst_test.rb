require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  attr_reader :test_sales_engine,
              :test_sales_analyst
  def setup
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoice_repository_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    @test_sales_engine = SalesEngine.from_csv({:items => item_path,
                                               :merchants => merchant_path,
                                               :invoices => invoice_path,
                                               :invoice_items => invoice_item_path,
                                               :transactions => transaction_path,
                                               :customers => customer_path})

    @test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  end

  def test_sales_analyst_exits
    assert_instance_of SalesAnalyst, test_sales_analyst
  end

  def test_it_has_access_to_all_items
    expected_ids = [263395237, 263396209, 263500440, 263501394,
                    263457553, 263459681, 263461291, 263562118,
                    263564776]

    assert_equal ItemRepository, test_sales_analyst.items.class
    assert_equal false, test_sales_analyst.items.repository.empty?
    assert_equal expected_ids.length, test_sales_analyst.items.repository.count
    test_sales_analyst.items.repository.each do |item|
      assert_equal true, expected_ids.include?(item.id)
    end
  end

  def test_it_has_access_to_all_merchants
    expected_ids = [12334141, 12334105, 12337041]

    assert_equal MerchantRepository, test_sales_analyst.merchants.class
    assert_equal false, test_sales_analyst.merchants.repository.empty?
    assert_equal expected_ids.length, test_sales_analyst.merchants.repository.count
    test_sales_analyst.merchants.repository.each do |merchant|
      assert_equal true, expected_ids.include?(merchant.id)
    end
  end

  def test_it_has_access_to_all_invoices
    expected_ids = [1963, 2202, 2254, 2345,
                    2354, 2969, 159, 292,
                    328, 224]

    assert_equal InvoiceRepository, test_sales_analyst.invoices.class
    assert_equal false, test_sales_analyst.invoices.repository.empty?
    assert_equal expected_ids.length, test_sales_analyst.invoices.repository.count
    test_sales_analyst.invoices.repository.each do |invoice|
      assert_equal true, expected_ids.include?(invoice.id)
    end
  end
end
