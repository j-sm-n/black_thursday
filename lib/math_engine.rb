require 'bigdecimal'
require 'pry'
module MathEngine

  def self.sum(numbers)
    numbers.reduce(:+)
  end

  def self.mean(numbers)
    BigDecimal.new(sum(numbers) / numbers.length)
  end

  def self.square(number)
    number ** 2
  end

  def self.deviation(number, mean)
    number - mean
  end

  def self.variance(numbers)
    sum(numbers.map { |number| square(deviation(number, mean(numbers))) }) / (numbers.length - 1)
  end

  def self.standard_deviation(numbers)
    Math.sqrt(variance(numbers)).to_f
  end

end
