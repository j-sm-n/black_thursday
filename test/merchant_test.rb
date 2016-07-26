require './test/test_helper'
require './lib/merchant'
require './lib/parser'

class MerchantTest < Minitest::Test
  attr_reader :m,
              :mr,
              :contents

  def setup
    @contents = Parser.new.load("./data/merchants_test.csv")
    @mr = MerchantRepository.new(contents)
    @m = Merchant.new({:id => 5, :name => "Turing School"})
  end

  def test_it_exists
    assert_instance_of Merchant, m
  end

  def test_it_has_an_id
    assert_equal 5, m.id
  end

  def test_it_has_a_name
    assert_equal "Turing School", m.name
  end

  def test_it_has_a_parent
    m.set_parent(mr)
    assert_equal mr, m.parent
  end

end
