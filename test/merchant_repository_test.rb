require './test/test_helper'
require './lib/merchant_repository'
require './lib/merchant'
require './lib/parser'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :mr,
              :contents,
              :merchant_1,
              :merchant_2

  def setup
    @contents = Parser.new.load("./data/merchants_test.csv")
    @mr = MerchantRepository.new(contents)
    @merchant_1 = Merchant.new({:id => 5, :name => "Turing School"})
    @merchant_2 = Merchant.new({:id => 12334145, :name => "BowlsByChris"})
  end

  def test_it_exists
    assert_instance_of MerchantRepository, mr
  end

  def test_it_has_a_count
    assert_equal 0, mr.count
  end

  def test_it_can_add_merchants
    mr << merchant_1
    actual_1 = mr.count
    mr << merchant_2
    actual_2 = mr.count

    assert_equal 1, actual_1
    assert_equal 2, actual_2
  end

  def test_it_can_return_all_merchants
    expected_1 = []
    actual_1 = mr.all
    assert_equal expected_1, actual_1

    mr << merchant_1
    mr << merchant_2
    expected_2 = [merchant_1, merchant_2]
    actual_2 = mr.all
    assert_equal expected_2, actual_2
  end

  def test_it_can_find_by_id
    mr << merchant_1
    mr << merchant_2
    actual_1 = mr.find_by_id(5)
    actual_2 = mr.find_by_id(12334145)
    actual_3 = mr.find_by_id(1606)
    expected_1 = merchant_1
    expected_2 = merchant_2
    expected_3 = nil

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
  end

  def test_it_can_find_by_name
    mr << merchant_1
    mr << merchant_2
    actual_1 = mr.find_by_name("Turing School")
    actual_1_case = mr.find_by_name("Turing SCHOOL")
    actual_2 = mr.find_by_name("BowlsByChris")
    actual_2_case = mr.find_by_name("BOWLSBYCHRIS")
    actual_3 = mr.find_by_name("Acme")
    expected_1 = merchant_1
    expected_2 = merchant_2
    expected_3 = nil

    assert_equal expected_1, actual_1
    assert_equal expected_1, actual_1_case
    assert_equal expected_2, actual_2
    assert_equal expected_2, actual_2_case
    assert_equal expected_3, actual_3
  end

  def test_it_can_find_all_by_name
    merchant_3 = Merchant.new({:id => 6, :name => "Turing School of Software Design"})
    merchant_4 = Merchant.new({:id => 7, :name => "Turing School of Software Design Front End"})
    merchant_5 = Merchant.new({:id => 8, :name => "Turing Computer Supply Chain"})
    merchant_6 = Merchant.new({:id => 9, :name => "Turing Test"})
    [merchant_1, merchant_2, merchant_3,
    merchant_4, merchant_5, merchant_6].each { |merchant| mr << merchant }
    expected_1 = [merchant_1, merchant_3, merchant_4, merchant_5, merchant_6]
    expected_2 = [merchant_2]
    expected_3 = []
    expected_4 = [merchant_1, merchant_3, merchant_4]

    actual_1 = mr.find_all_by_name("TUR")
    actual_2 = mr.find_all_by_name("B")
    actual_3 = mr.find_all_by_name("Velvet")
    actual_4 = mr.find_all_by_name("school")

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
    assert_equal expected_4, actual_4
  end

  def test_it_can_populate_itself_with_child_merchants
    mr.populate(contents)
    assert_instance_of Merchant, mr.find_by_id(12334496)
    assert_instance_of Merchant, mr.find_by_id(12334984)
    assert_instance_of Merchant, mr.find_by_id(12335918)
    assert_instance_of Merchant, mr.find_by_id(12335813)
    assert_instance_of Merchant, mr.merchants[0]
    assert_equal 9, mr.all.length
  end

  def test_it_can_parse_rows
      test_row = nil
      contents.each do |row|
        test_row = row
        break
      end
      actual = mr.parse_row(test_row)
      expected = {:id => test_row[:id],
                  :name => test_row[:name],
                  :created_at => test_row[:created_at],
                  :updated_at => test_row[:updated_at]}

     assert_equal expected, actual
  end
  

end
