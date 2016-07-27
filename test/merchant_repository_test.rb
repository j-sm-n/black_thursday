require './test/test_helper'
require './lib/merchant_repository'
require './lib/parser'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :test_merchant_repository,
              :contents,
              :merchant_1,
              :merchant_2

  def setup
    @contents = Parser.new.load("./data/merchants_test.csv")
    @test_merchant_repository = MerchantRepository.new(contents)
    @merchant_1 = Merchant.new({:id => 5,
                       :name => "Turing School",
                       :created_at => Time.now - (60 * 60),
                       :updated_at => Time.now},
                       test_merchant_repository)
    @merchant_2 = Merchant.new({:id => 12334145,
                       :name => "BowlsByChris",
                       :created_at => Time.now - (60 * 60),
                       :updated_at => Time.now},
                       test_merchant_repository)
  end

  def test_it_exists
    assert_instance_of MerchantRepository, test_merchant_repository
  end

  def test_it_has_a_count
    assert_equal 0, test_merchant_repository.count
  end

  def test_it_can_add_merchants
    test_merchant_repository << merchant_1
    actual_1 = test_merchant_repository.count
    test_merchant_repository << merchant_2
    actual_2 = test_merchant_repository.count

    assert_equal 1, actual_1
    assert_equal 2, actual_2
  end

  def test_it_can_return_all_merchants
    expected_1 = []
    actual_1 = test_merchant_repository.all
    assert_equal expected_1, actual_1

    test_merchant_repository << merchant_1
    test_merchant_repository << merchant_2
    expected_2 = [merchant_1, merchant_2]
    actual_2 = test_merchant_repository.all
    assert_equal expected_2, actual_2
  end

  def test_it_can_find_by_id
    test_merchant_repository << merchant_1
    test_merchant_repository << merchant_2
    actual_1 = test_merchant_repository.find_by_id(5)
    actual_2 = test_merchant_repository.find_by_id(12334145)
    actual_3 = test_merchant_repository.find_by_id(1606)
    expected_1 = merchant_1
    expected_2 = merchant_2
    expected_3 = nil

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
  end

  def test_it_can_find_by_name
    test_merchant_repository << merchant_1
    test_merchant_repository << merchant_2
    actual_1 = test_merchant_repository.find_by_name("Turing School")
    actual_1_case = test_merchant_repository.find_by_name("Turing SCHOOL")
    actual_2 = test_merchant_repository.find_by_name("BowlsByChris")
    actual_2_case = test_merchant_repository.find_by_name("BOWLSBYCHRIS")
    actual_3 = test_merchant_repository.find_by_name("Acme")
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
    merchant_3 = Merchant.new({:id => 6,
                               :name => "Turing School of Software Design",
                               :created_at => Time.now - (60 * 60),
                               :updated_at => Time.now},
                               test_merchant_repository)
    merchant_4 = Merchant.new({:id => 7,
                               :name => "Turing School of Software Design Front End",
                               :created_at => Time.now - (60 * 60),
                               :updated_at => Time.now},
                               test_merchant_repository)
    merchant_5 = Merchant.new({:id => 8,
                               :name => "Turing Computer Supply Chain",
                               :created_at => Time.now - (60 * 60),
                               :updated_at => Time.now},
                               test_merchant_repository)
    merchant_6 = Merchant.new({:id => 9,
                               :name => "Turing Test",
                               :created_at => Time.now - (60 * 60),
                               :updated_at => Time.now},
                               test_merchant_repository)
    [merchant_1, merchant_2, merchant_3,
    merchant_4, merchant_5, merchant_6].each { |merchant| test_merchant_repository << merchant }
    expected_1 = [merchant_1, merchant_3, merchant_4, merchant_5, merchant_6]
    expected_2 = [merchant_2]
    expected_3 = []
    expected_4 = [merchant_1, merchant_3, merchant_4]

    actual_1 = test_merchant_repository.find_all_by_name("TUR")
    actual_2 = test_merchant_repository.find_all_by_name("B")
    actual_3 = test_merchant_repository.find_all_by_name("Velvet")
    actual_4 = test_merchant_repository.find_all_by_name("school")

    assert_equal expected_1, actual_1
    assert_equal expected_2, actual_2
    assert_equal expected_3, actual_3
    assert_equal expected_4, actual_4
  end

  def test_it_can_populate_itself_with_child_merchants
    test_merchant_repository.populate(contents)
    assert_instance_of Merchant, test_merchant_repository.find_by_id(12334496)
    assert_instance_of Merchant, test_merchant_repository.find_by_id(12334984)
    assert_instance_of Merchant, test_merchant_repository.find_by_id(12335918)
    assert_instance_of Merchant, test_merchant_repository.find_by_id(12335813)
    assert_instance_of Merchant, test_merchant_repository.merchants[0]
    assert_equal 9, test_merchant_repository.all.length
  end

  def test_it_can_parse_rows
      test_row = nil
      contents.each do |row|
        test_row = row
        break
      end
      actual = test_merchant_repository.parse_row(test_row)
      expected = {:id => test_row[:id],
                  :name => test_row[:name],
                  :created_at => test_row[:created_at],
                  :updated_at => test_row[:updated_at]}

     assert_equal expected, actual
  end

end
