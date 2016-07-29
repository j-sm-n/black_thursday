require './test/test_helper'
require './lib/math_engine'

class MathEngineTest < Minitest::Test

  def test_it_takes_array_of_integers_and_returns_sum
    numbers = (1..10).to_a
    expected_sum = 55

    actual_sum = MathEngine.sum(numbers)

    assert_equal expected_sum, actual_sum
  end

  def test_it_takes_array_of_integers_and_returns_mean
    numbers = (1..10).to_a
    expected_mean = 5.5

    actual_mean = MathEngine.mean(numbers)

    assert_equal expected_mean, actual_mean
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

    actual_variance = MathEngine.variance(numbers)

    assert_equal expected_variance, actual_variance
  end

  def test_it_takes_array_of_integers_and_returns_standard_deviation
    numbers = (1..10).to_a
    expected_standard_deviation = 3.027650354

    actual_standard_deviation = MathEngine.standard_deviation(numbers)

    assert_equal expected_standard_deviation, actual_standard_deviation
  end
end
