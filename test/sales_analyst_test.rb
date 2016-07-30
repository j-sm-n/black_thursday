require './test/test_helper'
require './lib/sales_analyst'
require 'pry'

class SalesAnalystTest < Minitest::Test
  attr_reader :test_sales_engine,
              :test_sales_analyst
  def setup
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    @test_sales_engine = SalesEngine.from_csv({:items => item_path, :merchants => merchant_path})
    @test_sales_analyst = SalesAnalyst.new(test_sales_engine)
  end

  def test_sales_analyst_exitst
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
    test_sales_engine = SalesEngine.from_csv({:items => item_path, :merchants => merchant_path})
    test_sales_analyst = SalesAnalyst.new(test_sales_engine)

    expected_id_1 = [12334123]

    merchants = test_sales_analyst.merchants_with_high_item_count

    assert_equal false, merchants.empty?
    assert_equal 1, merchants.count
    assert_equal expected_id_1, merchants.map { |merchant| merchant.id }
  end

  def test_it_knows_the_average_price_of_a_merchants_items


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
    item_path = "./test/fixtures/sales_analyst_items_for_finding_average.csv"
    merchant_path = "./test/fixtures/sales_analyst_merchants_for_finding_average.csv"
    teste_sales_engine = SalesEngine.from_csv({:items => item_path, :merchants => merchant_path})
    test_sales_analyst = SalesAnalyst.new(teste_sales_engine)

    expected_mean_of_means = 14.89

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
