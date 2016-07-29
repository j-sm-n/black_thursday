require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  def test_sa_exitst
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_instance_of SalesAnalyst, sales_analyst
  end

  def test_it_has_access_to_all_items
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 9, sales_analyst.items.count
    assert_equal "510+ RealPush Icon Set", sales_analyst.items[0].name
  end

  def test_it_has_access_to_all_merchants
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 3, sales_analyst.merchants.count
    assert_equal "jejum", sales_analyst.merchants[0].name
  end

  def test_it_can_find_how_many_items_merchants_sell
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal [1, 3, 5], sales_analyst.find_how_many_items_merchants_sell
  end

  def test_it_can_find_average_of_items_sold
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 3.0, sales_analyst.average_item_count_per_merchant
  end

  def test_it_finds_the_variance_of_items
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 2.6666666666666665, sales_analyst.find_variance_of_items_sold
  end

  def test_it_finds_standard_deviation_of_items_sold
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)
    sales_analyst.find_variance_of_items_sold

    assert_equal 1.632993161855452, sales_analyst.average_items_per_merchant_standard_deviation
  end

  def test_can_produce_list_of_merchants_who_sell_the_most
    sales_engine = SalesEngine.from_csv({
                           :items     => "./test/fixtures/sales_analyst_items_for_finding_average.csv",
                           :merchants => "./test/fixtures/sales_analyst_merchants_for_finding_average.csv",
                         })
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal [sales_analyst.merchants[2]], sales_analyst.merchants_with_high_item_count
    refute_equal [sales_analyst.merchants[0]], sales_analyst.merchants_with_high_item_count
  end

  def test_it_knows_the_average_price_sold_by_merchant
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    teste_sales_engine = SalesEngine.from_csv({:items => item_path, :merchants => merchant_path})
    test_sales_analyst = SalesAnalyst.new(teste_sales_engine)

    merchant_id_1 = 12334141
    merchant_id_2 = 12334105
    merchant_id_3 = 12337041
    merchant_id_4 = 11111111

    expected_mean_1 = BigDecimal.new(12)
    expected_mean_2 = BigDecimal.new(16.66, 2)
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
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    teste_sales_engine = SalesEngine.from_csv({:items => item_path, :merchants => merchant_path})
    test_sales_analyst = SalesAnalyst.new(teste_sales_engine)

    expected_mean_of_means = BigDecimal.new(14.89,2)

    actual_mean_of_means = test_sales_analyst.average_average_price_per_merchant

    assert_equal expected_mean_of_means, actual_mean_of_means
  end

  def test_it_knows_golden_items
    item_path = "./test/fixtures/sales_analyst_golden_items.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    teste_sales_engine = SalesEngine.from_csv({:items => item_path, :merchants => merchant_path})
    test_sales_analyst = SalesAnalyst.new(teste_sales_engine)

    expected_golden_item_ids = [263426247, 263426657]

    actual_golden_items = test_sales_analyst.golden_items
    assert_equal false, actual_golden_items.nil?

    actual_golden_item_ids = actual_golden_items.map { |item| item.id }
    assert_equal expected_golden_item_ids, actual_golden_item_ids
  end
end
