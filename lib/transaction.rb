require 'bigdecimal'

class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :parent

  def initialize(data, parent)
    @id                          = data[:id].to_i
    @invoice_id                  = data[:invoice_id].to_i
    @credit_card_number          = data[:credit_card_number].to_i
    @credit_card_expiration_date = scrub(data[:credit_card_expiration_date])
    @result                      = data[:result]
    @created_at                  = Time.parse(data[:created_at])
    @updated_at                  = Time.parse(data[:updated_at])
    @parent                      = parent
  end

  def scrub(expiration_date)
    expiration_date.length == 3 ? "0" + expiration_date : expiration_date
  end

  def invoice
    parent.find_invoice_on_transaction(self.invoice_id)
  end

end
