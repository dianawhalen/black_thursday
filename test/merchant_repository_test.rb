require './test/test_helper'
require './lib/merchant_repository'
require './lib/sales_engine'
require './lib/merchant'

class MerchantRepositoryTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv"})

    @mr = @se.merchants
  end

  def test_it_can_load_csv
    skip
    assert_instance_of CSV
  end

  def test_it_can_find_merchant_by_name
    merchant = @mr.find_by_name("CJsDecor")
    assert_instance_of Merchant, merchant
  end

  def test_it_can_create_instance_of_merchant
    skip
    assert_equal Merchant, @mr.all
  end

  def test_it_can_return_array_of_all_known_merchant_instances
    assert_instance_of Array, @mr.all
  end
end
