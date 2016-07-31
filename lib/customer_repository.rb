require_relative '../lib/loader'
require_relative '../lib/repository'
require_relative '../lib/customer'

class CustomerRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize
    @repository
    @parent
  end

  def from_csv(file_path, parent=nil)
    @repository = Loader.load(file_path).map { |row| Customer.new(row, self) }
    @parent = parent
  end

  def find_all_by_first_name(first_name)
    repository.find_all do |customer|
      customer.first_name_downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    repository.find_all do |customer|
      customer.last_name_downcase.include?(last_name.downcase)
    end
  end

  def inspect
    "#<#{self.class} #{@repository.size} rows>"
  end

end
