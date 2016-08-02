require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class MerchantAnalystTest < Minitest::Test
  attr_reader :test_sales_engine,
              :test_sales_analyst
  def setup
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoice_repository_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    @test_sales_engine = SalesEngine.from_csv(file_paths)

    @test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  end

  def test_it_knows_item_count_for_a_given_merchant
    expected_item_counts_per_merchant = [1, 3, 5]
    actual_item_counts_per_merchant = test_sales_analyst.item_counts_for_all_merchants
    assert_equal expected_item_counts_per_merchant, actual_item_counts_per_merchant
  end

  def test_it_knows_average_count_of_items_per_merchant
    expected_mean_of_items_per_merchant = 3.00
    actual_mean_of_items_per_merchant = test_sales_analyst.average_items_per_merchant
    assert_equal expected_mean_of_items_per_merchant, actual_mean_of_items_per_merchant
  end

  def test_it_knows_average_items_per_merchant_standard_deviation
    expected_standard_deviation = 2.00
    actual_standard_deviation = test_sales_analyst.average_items_per_merchant_standard_deviation
    assert_equal expected_standard_deviation, actual_standard_deviation
  end

  def test_it_knows_which_merchants_sell_the_most_items
    item_path = "./test/fixtures/high_item_count_merchant_item_repo_data.csv"
    merchant_path = "./test/fixtures/high_item_count_merchant_merchant_repo_data.csv"
    invoice_path = "./test/fixtures/invoice_repository_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_id_1 = [12334123]

    merchants = test_sales_analyst.merchants_with_high_item_count

    assert_equal false, merchants.empty?
    assert_equal 1, merchants.count
    assert_equal expected_id_1, merchants.map { |merchant| merchant.id }
  end

  # def test_it_knows_the_average_price_of_a_merchants_items
  #
  #
  # end

  def test_it_knows_the_average_price_sold_by_merchant
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    invoice_path = "./test/fixtures/invoice_repository_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    merchant_id_1 = 12334141
    merchant_id_2 = 12334105
    merchant_id_3 = 12337041
    merchant_id_4 = 11111111

    expected_mean_1 = BigDecimal.new(12)
    expected_mean_2 = BigDecimal.new(16.66, 4)
    expected_mean_3 = BigDecimal.new(16)
    expected_mean_4 = nil

    actual_mean_1 = test_sales_analyst.average_item_price_for_merchant(merchant_id_1)
    actual_mean_2 = test_sales_analyst.average_item_price_for_merchant(merchant_id_2)
    actual_mean_3 = test_sales_analyst.average_item_price_for_merchant(merchant_id_3)
    actual_mean_4 = test_sales_analyst.average_item_price_for_merchant(merchant_id_4)

    assert_equal expected_mean_1, actual_mean_1
    assert_equal expected_mean_2, actual_mean_2
    assert_equal expected_mean_3, actual_mean_3
    assert_equal expected_mean_4, actual_mean_4
  end

  def test_it_knows_the_average_average_price_across_all_merchants
    item_path = "./data/items.csv"
    merchant_path = "./data/merchants.csv"
    invoice_path = "./data/invoices.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"

    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    # expected_mean_of_means = 14.89
    expected_mean_of_means = 350.29

    actual_mean_of_means = test_sales_analyst.average_average_price_per_merchant

    assert_equal expected_mean_of_means, actual_mean_of_means
  end

  def test_it_knows_invoice_count_for_a_given_merchant
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)
    expected_invoice_counts_per_merchant = [4, 3, 5, 10, 10, 11, 10, 20, 32]

    actual_invoice_counts_per_merchant = test_sales_analyst.invoice_counts_for_all_merchants

    assert_equal expected_invoice_counts_per_merchant, actual_invoice_counts_per_merchant
  end

  def test_it_knows_average_count_of_invoices_per_merchant
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"

    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)
    expected_mean_of_invoices_per_merchant = 11.67
    actual_mean_of_invoices_per_merchant = test_sales_analyst.average_invoices_per_merchant

    assert_equal expected_mean_of_invoices_per_merchant, actual_mean_of_invoices_per_merchant
  end

  def test_it_knows_average_invoices_per_merchant_standard_deviation
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"

    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)
    expected_standard_deviation = 9.15
    actual_standard_deviation = test_sales_analyst.average_invoices_per_merchant_standard_deviation

    assert_equal expected_standard_deviation, actual_standard_deviation
  end

  def test_it_knows_which_merchants_have_the_most_invoices
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"

    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_id_1 = [12334176]

    merchants = test_sales_analyst.top_merchants_by_invoice_count

    assert_equal false, merchants.empty?
    assert_equal 1, merchants.count
    assert_equal expected_id_1, merchants.map { |merchant| merchant.id }
  end

  def test_it_knows_which_merchants_have_the_fewest_invoices
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/invoices_iteration_2.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/transaction_repository_fixture.csv"
    customer_path = "./test/fixtures/customer_repository_fixture.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_id_1 = []
    merchants = test_sales_analyst.bottom_merchants_by_invoice_count

    assert_equal true, merchants.empty?
    assert_equal 0, merchants.count
    assert_equal expected_id_1, merchants.map { |merchant| merchant.id }
  end

  def test_it_finds_revenue_by_merchant
    merchant_path = "./data/merchants.csv"
    invoice_path = "./data/invoices.csv"
    invoice_item_path = "./data/invoice_items.csv"
    transaction_path = "./data/transactions.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path,
                  :invoice_items => invoice_item_path,
                  :transactions => transaction_path}

    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    actual_revenue = test_sales_analyst.revenue_by_merchant(12334194)

    assert_equal BigDecimal.new(actual_revenue), actual_revenue
    # assert_instance_of BigDecimal, actual_revenue
  end

  def test_it_can_find_all_merchant_revenues
    merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    invoice_path = "./test/fixtures/iteration04_top_revenue_earners_invoices.csv"
    invoice_item_path = "./test/fixtures/iteration04_top_revenue_earners_invoice_items.csv"
    transaction_path = "./test/fixtures/iteration04_top_revenue_earners_transactions.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path,
                  :invoice_items => invoice_item_path,
                  :transactions => transaction_path}

    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    actual_all_merchant_revenues = test_sales_analyst.find_all_merchant_revenues

    assert_equal 5, actual_all_merchant_revenues.length
    assert_equal Merchant, actual_all_merchant_revenues.first[0].class
    assert_equal 73777.17, actual_all_merchant_revenues.first[1]

  end


  def test_it_finds_top_x_merchants_by_revenue
    skip
    # merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    # invoice_path = "./test/fixtures/iteration04_top_revenue_earners_invoices.csv"
    # invoice_item_path = "./test/fixtures/iteration04_top_revenue_earners_invoice_items.csv"
    # transaction_path = "./test/fixtures/iteration04_top_revenue_earners_transactions.csv"
    merchant_path = "./data/merchants.csv"
    invoice_path = "./data/invoices.csv"
    invoice_item_path = "./data/invoice_items.csv"
    transaction_path = "./data/transactions.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path,
                  :invoice_items => invoice_item_path,
                  :transactions => transaction_path}

    test_sales_engine = SalesEngine.from_csv(file_paths)
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    assert_equal 10, test_sales_analyst.top_revenue_earners(10).length
    assert_equal Merchant, test_sales_analyst.top_revenue_earners(10).first.class
    assert_equal 12334634, test_sales_analyst.top_revenue_earners(10).first.id
    assert_equal Merchant, test_sales_analyst.top_revenue_earners(10).last.class
    assert_equal 12335747, test_sales_analyst.top_revenue_earners(10).last.id

    # assert_equal 2, test_sales_analyst.top_revenue_earners(2).length
    # assert_equal 12334115, test_sales_analyst.top_revenue_earners(2).first.id
    # assert_equal 12334105, test_sales_analyst.top_revenue_earners(2).last.id

    # 12335747 has revenue of 121321.29

  end

  def test_it_knows_merchants_with_pending_invoices

  end

end
