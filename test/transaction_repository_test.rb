require './test/test_helper'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

  attr_reader :test_transaction_repository,
              :parent

  def setup
    file_path = "./test/fixtures/transaction_repository_fixture.csv"
    @parent = Minitest::Mock.new
    @test_transaction_repository = TransactionRepository.new
    test_transaction_repository.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    assert_equal 3, test_transaction_repository.all.length
  end

  def test_invoice_item_repository_has_parent
    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", test_transaction_repository.parent.class
    assert parent.verify
  end

  # def test_it_can_find_all_by_invoice_id
  #
  # end

  def test_it_can_find_all_by_credit_card_number
    credit_card_number = 4848466917766329

    actual = test_transaction_repository.find_all_by_credit_card_number(credit_card_number)

    assert_equal 1, actual.length
    actual.each { |transaction| assert_equal Transaction, transaction.class }
    actual.each { |transaction| assert_equal credit_card_number, transaction.credit_card_number }
  end

  def test_it_can_find_all_by_result
    result_1 = "success"
    result_2 = "failed"

    actual_1 = test_transaction_repository.find_all_by_result(result_1)
    actual_2 = test_transaction_repository.find_all_by_result(result_2)

    assert_equal 2, actual_1.length
    actual_1.each { |transaction| assert_equal Transaction, transaction.class }
    actual_1.each { |transaction| assert_equal result_1, transaction.result }

    assert_equal 1, actual_2.length
    actual_2.each { |transaction| assert_equal Transaction, transaction.class }
    actual_2.each { |transaction| assert_equal result_2, transaction.result }
  end
end
