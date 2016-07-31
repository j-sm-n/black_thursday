require_relative '../lib/loader'
require_relative '../lib/repository'
require_relative '../lib/transaction'

class TransactionRepository
  include Repository

  attr_reader :repository,
              :parent

  def initialize
    @repository
    @parent
  end

  def from_csv(file_path, parent=nil)
    @repository = Loader.load(file_path).map { |row| Transaction.new(row, self) }
    @parent = parent
  end

  # def find_all_by_invoice_id(invoice_id)
  #   # repository.find_all { |transaction| transaction.invoice_id == invoice_id }
  # end

  def find_all_by_credit_card_number(credit_card_number)
    repository.find_all { |transaction| transaction.credit_card_number == credit_card_number }
  end

  def find_all_by_result(result)
    repository.find_all { |transaction| transaction.result == result }
  end

  def inspect
    "#<#{self.class} #{@repository.size} rows>"
  end

end
