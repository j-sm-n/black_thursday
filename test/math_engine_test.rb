require './test/test_helper'
require './lib/math_engine'

class MathEngineTest < Minitest::Test

  def test_it_takes_array_of_integers_and_returns_sum
    numbers_1 = (1..10).to_a
    expected_sum = 55

    actual_sum = MathEngine.sum(numbers_1)

    assert_equal expected_sum, actual_sum
  end

  def test_it_takes_array_of_integers_and_returns_mean
    numbers_1 = (1..10).to_a
    numbers_2 = [1, 2, 3, 4, 5, 6, 7, 8, 15]
    expected_mean_1 = 5.50
    expected_mean_2 = 5.67

    actual_mean_1 = MathEngine.mean(numbers_1)
    actual_mean_2 = MathEngine.mean(numbers_2)

    assert_equal expected_mean_1, actual_mean_1
    assert_equal expected_mean_2, actual_mean_2
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
    expected_variance = 9.166666667

    actual_variance = MathEngine.variance(numbers).round(9)

    assert_equal expected_variance, actual_variance
  end

  def test_it_takes_array_of_integers_and_returns_standard_deviation
    numbers_1 = (1..10).to_a
    numbers_2 = [499, 498, 206, 171, 522, 415, 578, 504, 315, 194]
    expected_standard_deviation_1 = 3.03
    expected_standard_deviation_2 = 154.84

    actual_standard_deviation_1 = MathEngine.standard_deviation(numbers_1)
    actual_standard_deviation_2 = MathEngine.standard_deviation(numbers_2)

    assert_equal expected_standard_deviation_1, actual_standard_deviation_1
    assert_equal expected_standard_deviation_2, actual_standard_deviation_2
  end
end
