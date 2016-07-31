require './test/test_helper'
require './lib/math_engine'
require './data/some_long_arrays'


class MathEngineTest < Minitest::Test

  def test_it_takes_array_of_integers_and_returns_sum
    numbers_1 = (1..10).to_a
    numbers_2 = [5, -3]

    expected_sum_1 = 55
    expected_sum_2 = 2

    actual_sum_1 = MathEngine.sum(numbers_1)
    actual_sum_2 = MathEngine.sum(numbers_2)

    assert_equal expected_sum_1, actual_sum_1
    assert_equal expected_sum_2, actual_sum_2
  end

  def test_it_takes_array_of_integers_and_returns_mean
    numbers_1 = (1..10).to_a
    numbers_2 = [29.99, 9.99, 9.99]
    numbers_3 = ACTUAL_AVERAGE_PRICES_PER_MERCHANT

    expected_mean_1 = BigDecimal.new("5.50")
    expected_mean_2 = BigDecimal.new("16.66")
    expected_mean_3 = BigDecimal.new("350.29")

    actual_mean_1 = MathEngine.mean(numbers_1)
    actual_mean_2 = MathEngine.mean(numbers_2)
    actual_mean_3 = MathEngine.mean(numbers_3)

    assert_equal expected_mean_1, actual_mean_1
    assert_equal expected_mean_2, actual_mean_2
    assert_equal expected_mean_3, actual_mean_3
  end

  def test_it_takes_total_and_integer_and_returns_percentage
    number_1 = 0
    number_2 = 5
    number_3 = 10

    total = 50

    actual_percentage_1 = MathEngine.percentage(number_1, total)
    actual_percentage_2 = MathEngine.percentage(number_2, total)
    actual_percentage_3 = MathEngine.percentage(number_3, total)

    assert_equal 0, actual_percentage_1
    assert_equal 10, actual_percentage_2
    assert_equal 20, actual_percentage_3
  end

  def test_it_takes_an_integer_and_returns_integer_squared
    number_1 = 0
    number_2 = 5
    number_3 = 10

    actual_square_1 = MathEngine.square(number_1)
    actual_square_2 = MathEngine.square(number_2)
    actual_square_3 = MathEngine.square(number_3)

    assert_equal 0, actual_square_1
    assert_equal 25, actual_square_2
    assert_equal 100, actual_square_3
  end

  def test_it_takes_an_integer_and_returns_integer_doubled
    number_1 = 0
    number_2 = 5
    number_3 = 10

    actual_double_1 = MathEngine.double(number_1)
    actual_double_2 = MathEngine.double(number_2)
    actual_double_3 = MathEngine.double(number_3)

    assert_equal 0, actual_double_1
    assert_equal 10, actual_double_2
    assert_equal 20, actual_double_3
  end

  def test_it_takes_a_number_and_mean_and_returns_deviation
    number_1 = 10
    mean_1 = 9

    number_2 = 54321
    mean_2 = 10000

    actual_deviation_1 = MathEngine.deviation(number_1, mean_1)
    actual_deviation_2 = MathEngine.deviation(number_2, mean_2)

    assert_equal 1, actual_deviation_1
    assert_equal 44321, actual_deviation_2
  end

  def test_it_takes_an_integer_and_mean_and_returns_square_deviation
    mean = 5.5
    number = 1
    expected = 20.25

    actual = MathEngine.square_deviation(number, mean)

    assert_equal expected, actual
  end

  def test_it_takes_array_of_integers_and_returns_numerator_of_variance
    numbers = (1..10).to_a
    expected = 82.5

    actual = MathEngine.variance_numerator(numbers)

    assert_equal expected, actual
  end

  def test_it_takes_array_of_integers_and_returns_variance
    numbers = (1..10).to_a
    expected_variance = BigDecimal.new("9.166666667")

    actual_variance = MathEngine.variance(numbers).round(9)

    assert_equal expected_variance, actual_variance
  end

  def test_it_takes_array_of_integers_and_returns_standard_deviation
    numbers_1 = (1..10).to_a
    numbers_2 = ACTUAL_ITEM_COUNT_PER_MERCHANT
    expected_standard_deviation_1 = 3.03
    expected_standard_deviation_2 = 3.26

    actual_standard_deviation_1 = MathEngine.standard_deviation(numbers_1)
    actual_standard_deviation_2 = MathEngine.standard_deviation(numbers_2)

    assert_equal expected_standard_deviation_1, actual_standard_deviation_1
    assert_equal expected_standard_deviation_2, actual_standard_deviation_2
  end

  def test_it_can_find_top_outliers
    numbers_1 = [81, 2, 13, 71, 78, 80, 12, 36]
    numbers_2 = ACTUAL_ITEM_COUNT_PER_MERCHANT

    mean_1 = MathEngine.mean(numbers_1)
    mean_2 = MathEngine.mean(numbers_2)

    standard_deviation_1 = MathEngine.standard_deviation(numbers_1)
    standard_deviation_2 = MathEngine.standard_deviation(numbers_2)

    test_case = numbers_2.find_all do |number|
      MathEngine.outlier?(number, mean_2, standard_deviation_2, 1)
    end

    assert_equal true, MathEngine.outlier?(82, mean_1, standard_deviation_1, 1)
    assert_equal true, MathEngine.outlier?(116, mean_1, standard_deviation_1, 2)
    assert_equal true, MathEngine.outlier?(150, mean_1, standard_deviation_1, 3)

    assert_equal false, MathEngine.outlier?(82, mean_1, standard_deviation_1, 2)
    assert_equal false, MathEngine.outlier?(116, mean_1, standard_deviation_1, 3)
    assert_equal false, MathEngine.outlier?(150, mean_1, standard_deviation_1, 4)

    assert_equal 52, test_case.length
  end
end
