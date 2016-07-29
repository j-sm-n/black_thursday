require 'bigdecimal'
require 'pry'
module MathEngine

  def self.sum(numbers)
    numbers.reduce(0) { |result, number| result += number.to_f}
  end

  def self.mean(numbers)
    (sum(numbers) / numbers.length)
  end

  def self.square(number)
    number ** 2
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
    (variance_numerator(numbers) / (numbers.length - 1)).round(9)
  end

  def self.standard_deviation(numbers)
    Math.sqrt(variance(numbers)).round(9)
  end
end
