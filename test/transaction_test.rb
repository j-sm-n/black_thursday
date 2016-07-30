require './test/test_helper'
require './lib/loader'
require './lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :test_transaction,
              :parent

  def setup
    contents = Loader.load("./test/fixtures/transaction_fixture.csv")
    @parent = Minitest::Mock.new
    contents.each do |data|
      @test_transaction = Transaction.new(data, parent)
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

    assert_equal expected_id, test_transaction.id
    assert_equal expected_invoice_id, test_transaction.invoice_id
    assert_equal expected_credit_card_number,
                 test_transaction.credit_card_number
    assert_equal expected_credit_card_expiration_date,
                 test_transaction.credit_card_expiration_date
    assert_equal expected_result, test_transaction.result
    assert_equal expected_created_at, test_transaction.created_at
    assert_equal expected_updated_at, test_transaction.updated_at
  end

  def test_transaction_has_parent
    parent.expect(:class, "TransactionRepository")
    assert_equal "TransactionRepository", test_transaction.parent.class
    assert parent.verify
  end

  def test_transaction_can_scrub_credit_card_expiration_date
    test_date_1 = "217"
    test_date_2 = "1217"

    expected_1 = "0217"
    expected_2 = "1217"

    assert_equal expected_1, test_transaction.scrub_expiration_date(test_date_1)
    assert_equal expected_2, test_transaction.scrub_expiration_date(test_date_2)
  end

end
