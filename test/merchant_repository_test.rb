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

  def test_it_can_find_merchant_by_name
    assert_instance_of Merchant, @mr.find_by_name("CJsDecor")
  end

  def test_it_can_create_instance_of_merchant
    assert_instance_of Merchant
  end

  def test_it_can_return_array_of_all_known_merchant_instances
    assert
  end
end
