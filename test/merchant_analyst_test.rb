require './test/test_helper'
require './lib/sales_analyst'

class MerchantAnalystTest < Minitest::Test
  attr_reader :engine,
              :analyst
  def setup
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    invoice_path = "./test/fixtures/invoice_repository_fixture.csv"
    invoice_item_path = "./test/fixtures/invoice_item_repository_fixture.csv"
    transaction_path = "./test/fixtures/3_transactions.csv"
    customer_path = "./test/fixtures/92_customers.csv"
    file_paths = {:items => item_path, :merchants => merchant_path,
                  :invoices => invoice_path, :invoice_items => invoice_item_path,
                  :transactions => transaction_path, :customers => customer_path}
    @engine = SalesEngine.from_csv(file_paths)

    @analyst = SalesAnalyst.new(engine)
  end

  def test_it_knows_item_count_for_a_given_merchant
    expected_item_counts_per_merchant = [1, 3, 5]
    actual_item_counts_per_merchant = analyst.item_counts_for_all_merchants
    assert_equal expected_item_counts_per_merchant, actual_item_counts_per_merchant
  end

  def test_it_knows_average_count_of_items_per_merchant
    expected_mean_of_items_per_merchant = 3.00
    actual_mean_of_items_per_merchant = analyst.average_items_per_merchant
    assert_equal expected_mean_of_items_per_merchant, actual_mean_of_items_per_merchant
  end

  def test_it_knows_average_items_per_merchant_standard_deviation
    expected = 2.00
    actual = analyst.average_items_per_merchant_standard_deviation
    assert_equal expected, actual
  end

  def test_it_knows_which_merchants_sell_the_most_items
    item_path = "./test/fixtures/34_items.csv"
    merchant_path = "./test/fixtures/4_merchants.csv"
    file_paths = {:items => item_path, :merchants => merchant_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    expected_id_1 = [12334123]

    merchants = analyst.merchants_with_high_item_count

    assert_equal false, merchants.empty?
    assert_equal 1, merchants.count
    assert_equal expected_id_1, merchants.map { |merchant| merchant.id }
  end

  def test_it_knows_the_average_price_sold_by_merchant
    item_path = "./test/fixtures/9_items.csv"
    merchant_path = "./test/fixtures/3_merchants.csv"
    file_paths = {:items => item_path, :merchants => merchant_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    id_1 = 12334141
    id_2 = 12334105
    id_3 = 12337041
    id_4 = 11111111

    expected_1 = BigDecimal.new(12)
    expected_2 = BigDecimal.new(16.66, 4)
    expected_3 = BigDecimal.new(16)
    expected_4 = nil

    actual_1 = analyst.average_item_price_for_merchant(id_1)
    actual_2 = analyst.average_item_price_for_merchant(id_2)
    actual_3 = analyst.average_item_price_for_merchant(id_3)
    actual_4 = analyst.average_item_price_for_merchant(id_4)

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
    assert_equal expected_4, actual_4
  end

  def test_it_knows_the_average_average_price_across_all_merchants

    item_path = "./data/items.csv"
    merchant_path = "./data/merchants.csv"
    invoice_path = "./data/invoices.csv"
    file_paths = {:items => item_path,
                  :merchants => merchant_path,
                  :invoices => invoice_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    expected_mean_of_means = 350.29

    actual_mean_of_means = analyst.average_average_price_per_merchant

    assert_equal expected_mean_of_means, actual_mean_of_means
  end

  def test_it_knows_invoice_count_for_a_given_merchant
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)
    expected_invoice_counts_per_merchant = [4, 3, 5, 10, 10, 11, 10, 20, 32]

    actual_invoice_counts_per_merchant = analyst.invoice_counts_for_all_merchants

    assert_equal expected_invoice_counts_per_merchant, actual_invoice_counts_per_merchant
  end

  def test_it_knows_average_count_of_invoices_per_merchant
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)
    expected_mean_of_invoices_per_merchant = 11.67
    actual_mean_of_invoices_per_merchant = analyst.average_invoices_per_merchant

    assert_equal expected_mean_of_invoices_per_merchant, actual_mean_of_invoices_per_merchant
  end

  def test_it_knows_average_invoices_per_merchant_standard_deviation
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)
    expected_standard_deviation = 9.15
    actual_standard_deviation = analyst.average_invoices_per_merchant_standard_deviation

    assert_equal expected_standard_deviation, actual_standard_deviation
  end

  def test_it_knows_which_merchants_have_the_most_invoices
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    expected_id_1 = [12334176]

    merchants = analyst.top_merchants_by_invoice_count

    assert_equal false, merchants.empty?
    assert_equal 1, merchants.count
    assert_equal expected_id_1, merchants.map { |merchant| merchant.id }
  end

  def test_it_knows_which_merchants_have_the_fewest_invoices
    merchant_path = "./test/fixtures/merchants_iteration_2.csv"
    invoice_path = "./test/fixtures/107_invoices.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path}
    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    expected_id_1 = []
    merchants = analyst.bottom_merchants_by_invoice_count

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

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual_revenue = analyst.revenue_by_merchant(12334194)

    assert_equal BigDecimal.new(actual_revenue), actual_revenue
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

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual_all_merchant_revenues = analyst.find_all_merchant_revenues

    assert_equal 5, actual_all_merchant_revenues.length
    assert_equal Merchant, actual_all_merchant_revenues.first[0].class
    assert_equal 73777.17, actual_all_merchant_revenues.first[1]
  end


  def test_it_finds_top_x_merchants_by_revenue
    merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    invoice_path = "./test/fixtures/iteration04_top_revenue_earners_invoices.csv"
    invoice_item_path = "./test/fixtures/iteration04_top_revenue_earners_invoice_items.csv"
    transaction_path = "./test/fixtures/iteration04_top_revenue_earners_transactions.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path,
                  :invoice_items => invoice_item_path,
                  :transactions => transaction_path}

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual_top_10_merchants = analyst.top_revenue_earners(10)
    actual_top_20_merchants = analyst.top_revenue_earners

    assert_equal 5, actual_top_10_merchants.length
    assert_equal Merchant, actual_top_10_merchants.first.class
    assert_equal 12334115, actual_top_10_merchants.first.id
    assert_equal Merchant, actual_top_10_merchants.last.class
    assert_equal 12334123, actual_top_10_merchants.last.id

    assert_equal 5, actual_top_20_merchants.length
  end

  def test_it_knows_all_merchants_ranked_by_revenue
    merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    invoice_path = "./test/fixtures/iteration04_top_revenue_earners_invoices.csv"
    invoice_item_path = "./test/fixtures/iteration04_top_revenue_earners_invoice_items.csv"
    transaction_path = "./test/fixtures/iteration04_top_revenue_earners_transactions.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path,
                  :invoice_items => invoice_item_path,
                  :transactions => transaction_path}

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual_ranked_merchants = analyst.merchants_ranked_by_revenue

    assert_equal Merchant, actual_ranked_merchants.first.class
    assert_equal 12334115, actual_ranked_merchants.first.id
    assert_equal Merchant, actual_ranked_merchants.last.class
    assert_equal 12334123, actual_ranked_merchants.last.id
  end

  def test_it_knows_merchants_with_pending_invoices
    merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    invoice_path = "./test/fixtures/iteration04_top_revenue_earners_invoices.csv"
    transaction_path = "./test/fixtures/iteration04_top_revenue_earners_transactions.csv"
    file_paths = {:merchants => merchant_path,
                  :invoices => invoice_path,
                  :transactions => transaction_path}

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual = analyst.merchants_with_pending_invoices

    assert_equal 5, actual.length
    assert_equal Merchant, actual.first.class
  end

  def test_it_knows_merchants_with_only_one_item
    merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    item_path = "./data/items.csv"
    file_paths = {:merchants => merchant_path,
                  :items => item_path}

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual = analyst.merchants_with_only_one_item

    assert_equal 3, actual.length
    assert_equal Merchant, actual.first.class
  end

  def test_it_knows_merchants_registered_in_month_with_only_one_item
    merchant_path = "./test/fixtures/iteration04_top_revenue_earners_merchants.csv"
    item_path = "./data/items.csv"
    file_paths = {:merchants => merchant_path,
                  :items => item_path}

    engine = SalesEngine.from_csv(file_paths)
    analyst = SalesAnalyst.new(engine)

    actual_1 = analyst.merchants_with_only_one_item_registered_in_month("March")
    actual_2 = analyst.merchants_with_only_one_item_registered_in_month("June")
    actual_3 = analyst.merchants_with_only_one_item_registered_in_month("January")

    assert_equal 1, actual_1.length
    assert_instance_of Merchant, actual_1.first
    assert_equal 1, actual_2.length
    assert_instance_of Merchant, actual_2.first
    assert_equal 0, actual_3.length
  end

  def test_it_knows_month_names_from_number
    assert_equal "January", analyst.month_number_to_name(1)
    assert_equal "December", analyst.month_number_to_name(12)
  end

end
