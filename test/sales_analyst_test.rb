require './test/test_helper'
require './lib/sales_analyst'
require './lib/sales_engine'

class SalesAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :merchants => "./data/merchants.csv",
      :items     => "./data/items.csv",
      :customers => "./data/customers.csv",
      :invoices  => "./data/invoices.csv",
      :invoice_items => "./test/fixtures/invoice_items_truncated.csv",
      :transactions  => "./test/fixtures/transactions_truncated.csv"
      })

    @sa = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sa
  end

  def test_it_has_sales_engine
    assert_instance_of SalesEngine, @sa.engine
  end

  def test_merchant_returns_correct_count
    assert_equal 475, @sa.merchant_count
  end

  def test_item_test_returns_correct_count
    assert_equal 1367, @sa.item_count
  end

  def test_merchent_items_count_returns_correct_item_count_for_given_merchant
    assert_equal 1, @sa.merchant_items_count(12334112)
  end

  def test_it_returns_average_items_per_merchant
    assert_equal 2.88, @sa.average_items_per_merchant
  end

  def test_it_can_find_average_items_per_merchant_std_deviation
    assert_equal 3.26, @sa.average_items_per_merchant_standard_deviation
  end

  def test_returns_array_of_high_item_count_merchants
    assert_instance_of Array, @sa.merchants_with_high_item_count
  end

  def test_merchant_items_returns_array_with_items_of_given_merchant
    items_of_merchant = @sa.merchant_items(12334112)

    assert_instance_of Array, items_of_merchant
    assert_equal Item, items_of_merchant.first.class
    assert_equal 1, items_of_merchant.count
  end

  def test_returns_bigdecimal_for_average_item_price_given_merchant_id
    assert_instance_of BigDecimal, @sa.average_item_price_for_merchant(12334112)
  end

  def test_average_average_price_per_merchant_returns_bigdecimal
    assert_instance_of BigDecimal, @sa.average_average_price_per_merchant
  end

  def tests_average_item_price_returns_correct_float
    assert_instance_of BigDecimal, @sa.average_item_price
  end

  def test_it_can_find_item_price_std_deviation
    assert_equal 2900.98999734588, @sa.standard_deviation_item_price
  end

  def test_golden_items_returns_array
    assert_instance_of Array, @sa.golden_items
  end

  def test_returns_correct_invoices_count
    assert_equal 4985, @sa.invoices_count
  end

  def test_it_can_return_average_invoices_per_merchant
    assert_equal 10.49, @sa.average_invoices_per_merchant
  end

  def test_merchant_invoice_count_returns_integer
    assert_instance_of Fixnum, @sa.merchant_invoice_count(342)
  end

  def test_it_can_return_std_dev_of_average_invoices_per_merchant
    assert_equal 3.29, @sa.average_invoices_per_merchant_standard_deviation
  end

  def test_returns_array_of_top_performing_merchants_by_invoice_count
    assert_instance_of Array, @sa.top_merchants_by_invoice_count
    assert_instance_of Merchant, @sa.top_merchants_by_invoice_count.first
  end

  def test_returns_array_of_bottom_performing_merchants_by_invoice_count
    assert_instance_of Array, @sa.bottom_merchants_by_invoice_count
    assert_instance_of Merchant, @sa.bottom_merchants_by_invoice_count.first
  end

  def test_invoice_day_created_returns_array_of_day_names
    assert_instance_of Array, @sa.invoice_day_created
    assert_equal 'Saturday', @sa.invoice_day_created.first
  end

  def test_invoice_created_on_given_day_returns_hash
    assert_instance_of Hash, @sa.number_of_invoices_created_on_given_day
    assert_equal 7, @sa.number_of_invoices_created_on_given_day.keys.count
  end

  def test_invoice_created_day_std_dev_returns_correct_number
    assert_equal 18.07, @sa.invoice_created_day_standard_deviation
  end

  def test_returns_array_of_strings_for_top_performing_days
    assert_instance_of Array, @sa.top_days_by_invoice_count
    assert_instance_of String, @sa.top_days_by_invoice_count.first
  end

  def test_invoice_status_count_returns_correct_number
    assert_equal 2839, @sa.invoice_statuses_count(:shipped)
  end

  def test_returns_correct_percentage_status
    assert_equal 29.55, @sa.invoice_status(:pending)
    assert_equal 56.95, @sa.invoice_status(:shipped)
    assert_equal 13.5, @sa.invoice_status(:returned)
  end

  def test_it_returns_total_revenue_by_date
    assert_instance_of BigDecimal, @sa.total_revenue_by_date(Time.parse("2008-08-28"))
  end

  def test_it_returns_array_of_merchants_ranked_by_revenue
    assert_instance_of Array, @sa.merchants_ranked_by_revenue
    assert_equal 475, @sa.merchants_ranked_by_revenue.count
  end

  def test_top_revenue_earners_returns_array_of_merchants
    assert_equal 20, @sa.top_revenue_earners.count
    assert_equal 15, @sa.top_revenue_earners(15).count
    assert_instance_of Merchant, @sa.top_revenue_earners.first
    assert_equal "jejum", @sa.top_revenue_earners.first.name
  end

  def test_returns_merchants_with_pending_invoices
    assert_instance_of Array, @sa.merchants_with_pending_invoices
    assert_equal 475, @sa.merchants_with_pending_invoices.count
  end

  def test_it_returns_array_of_merchants_with_only_one_item
    assert_instance_of Array, @sa.merchants_with_only_one_item
    assert_equal 243, @sa.merchants_with_only_one_item.count
  end

  def test_merchants_with_only_one_item_registered_in_month
    assert_instance_of Array, @sa.merchants_with_only_one_item_registered_in_month("December")
    assert_equal 15, @sa.merchants_with_only_one_item_registered_in_month("December").count
  end

  def test_returns_total_revenue_for_given_merchant
    assert_equal 86753, @sa.revenue_by_merchant(12334141).to_i
  end

  def test_returns_array_of_most_sold_items_for_given_merchant
    assert_instance_of Array, @sa.most_sold_item_for_merchant(12334141)
    assert_equal 4, @sa.most_sold_item_for_merchant(12334141).count
  end

  def test_returns_best_item_for_merchant_by_revenue
    assert_instance_of Item, @sa.best_item_for_merchant(12334141)
    assert_equal "Seer", @sa.best_item_for_merchant(12334141).name
  end
end
