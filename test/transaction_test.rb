require './test/test_helper'
require './lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :transaction,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/transaction_fixture.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @transaction = Transaction.new(data, parent)
    end
  end

  def test_it_has_all_the_properties_of_a_transaction
    expected_id                          = 4985
    expected_invoice_id                  = 3791
    expected_credit_card_number          = 4772428113593836
    expected_credit_card_expiration_date = "0913"
    expected_result                      = "success"
    expected_created_at                  = Time.parse("2012-02-26 20:59:39 UTC")
    expected_updated_at                  = Time.parse("2012-02-26 20:59:39 UTC")

    assert_equal expected_id, transaction.id
    assert_equal expected_invoice_id, transaction.invoice_id
    assert_equal expected_credit_card_number,
                 transaction.credit_card_number
    assert_equal expected_credit_card_expiration_date,
                 transaction.credit_card_expiration_date
    assert_equal expected_result, transaction.result
    assert_equal expected_created_at, transaction.created_at
    assert_equal expected_updated_at, transaction.updated_at
  end

  def test_transaction_has_parent
    parent.expect(:class, "TransactionRepository")
    assert_equal "TransactionRepository", transaction.parent.class
    assert parent.verify
  end

  def test_transaction_can_scrub_credit_card_expiration_date
    test_date_1 = "217"
    test_date_2 = "1217"

    expected_1 = "0217"
    expected_2 = "1217"

    assert_equal expected_1, transaction.scrub_expiration_date(test_date_1)
    assert_equal expected_2, transaction.scrub_expiration_date(test_date_2)
  end

  def test_transaction_can_return_invoice
    parent.expect(:find_invoice_on_transaction, "invoice", [3791])

    actual_invoice = transaction.invoice

    assert_equal "invoice", actual_invoice
    assert parent.verify
  end

end
