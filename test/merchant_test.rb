require './test/test_helper'
require './lib/merchant'
require_relative '../lib/sales_engine'
require_relative '../lib/merchant_repository'

class MerchantTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :merchants => "./data/merchants.csv",
      :items     => "./data/items.csv",
      :customers => "./data/customers.csv",
      :invoices  => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv"
      })

    @m = Merchant.new({:id => "5",
      :name => "Turing School", :created_at  => "2003-09-10"
      }, @se.merchants)
  end

  def test_it_exists
    assert_instance_of Merchant, @m
  end

  def test_every_merchant_has_a_merchant_repo_parent
    assert @m.parent, @se.merchants
  end

  def test_it_has_id
    assert_equal 5, @m.id
  end

  def test_it_has_name
    assert_equal "Turing School", @m.name
  end

  def test_it_can_return_all_items_by_merchant_id
    assert_equal 0, @m.items.count
  end

  def test_it_can_return_all_invoices_by_merchant_id
    assert_equal 0, @m.invoices.count
  end

  def test_it_can_return_array_of_customers
    assert_instance_of Array, @m.customers
    assert_equal 0, @m.customers.count
  end

  def test_returns_revenue_for_merchant
    merchant = @se.merchants.find_by_id(12334132)
    assert_equal 102699, merchant.revenue.to_i
  end
end
