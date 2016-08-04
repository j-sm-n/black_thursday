require './test/test_helper'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test

  attr_reader :transaction_repo,
              :parent

  def setup
    file_path = "./test/fixtures/3_transactions.csv"
    @parent = Minitest::Mock.new
    @transaction_repo = TransactionRepository.new
    transaction_repo.from_csv(file_path, parent)
  end

  def test_from_csv_loads_items_to_repository
    assert_equal 3, transaction_repo.all.length
  end

  def test_invoice_item_repository_has_parent
    parent.expect(:class, "SalesEngine")
    assert_equal "SalesEngine", transaction_repo.parent.class
    assert parent.verify
  end

  def test_it_can_find_all_by_credit_card_number
    credit_card_number = 4848466917766329

    actual = transaction_repo.find_all_by_credit_card_number(credit_card_number)

    assert_instance_of Array, actual

    actual.each do |transaction|
      assert_equal Transaction, transaction.class
    end

    actual.each do |transaction|
      assert_equal credit_card_number, transaction.credit_card_number
    end
  end

  def test_it_can_find_all_by_result
    result_1 = "success"
    result_2 = "failed"

    actual_1 = transaction_repo.find_all_by_result(result_1)
    actual_2 = transaction_repo.find_all_by_result(result_2)

    assert_equal 2, actual_1.length
    actual_1.each { |transaction| assert_equal Transaction, transaction.class }
    actual_1.each { |transaction| assert_equal result_1, transaction.result }

    assert_equal 1, actual_2.length
    actual_2.each { |transaction| assert_equal Transaction, transaction.class }
    actual_2.each { |transaction| assert_equal result_2, transaction.result }
  end

  def test_it_knows_the_customer_on_an_invoice
    parent.expect(:find_invoice_on_transaction, "invoice", ["invoice_id"])
    actual_invoice = transaction_repo.find_invoice_on_transaction("invoice_id")
    assert_equal "invoice", actual_invoice
  end
end
