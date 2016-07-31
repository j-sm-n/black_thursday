require 'bigdecimal'
require 'pry'
module MathEngine

  def self.sum(numbers)
    numbers.reduce(0.0) { |result, number| result += number}
  end

  def self.mean(numbers)
    BigDecimal.new(((sum(numbers) / numbers.length)).round(2),10)
  end

  def self.percentage(number, total)
    ((number / (total).to_f) * 100).round(2)
  end

  def self.square(number)
    number ** 2
  end

  def self.double(number)
    number * 2
  end

  def self.deviation(number, mean)
    number - mean
  end

  def self.square_deviation(number, mean)
    square(deviation(number, mean))
  end

  def self.variance_numerator(numbers)
    sum(numbers.map { |number| square(deviation(number, mean(numbers))) })
  end

  def self.variance(numbers)
    (variance_numerator(numbers) / (numbers.length - 1))
  end

  def self.standard_deviation(numbers)
    Math.sqrt(variance(numbers)).round(2)
  end

  def self.outlier?(number, mean, standard_deviation, deviations)
    if deviations < 0
      number < sum([mean, standard_deviation * deviations])
    else
      number > sum([mean, standard_deviation * deviations])
    end
  end
end
