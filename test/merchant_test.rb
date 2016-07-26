require './test/test_helper'
require './lib/merchant'

class MerchantTest < Minitest::Test
  attr_reader :m

  def setup
    @m = Merchant.new("12334496", "ElaineClausonArt")
  end

  def test_it_exists
    assert_instance_of Merchant, @m
  end

  def test_it_has_an_id
    assert_equal "12334496", @m.id
  end

  def test_it_has_a_name
    assert_equal "ElaineClausonArt", @m.name
  end

end
