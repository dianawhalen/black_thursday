require './test/test_helper'
require './lib/invoice'
require_relative '../lib/sales_engine'
require_relative '../lib/invoice_repository'

class InvoiceTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :merchants => "./data/merchants.csv",
      :items     => "./data/items.csv",
      :customers => "./data/customers.csv",
      :invoices  => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions  => "./data/transactions.csv"
      })

    @iv = Invoice.new({
      :id          => 397,
      :customer_id => 79,
      :merchant_id => 12334284,
      :status      => "shipped",
      :created_at  => "2003-09-10",
      :updated_at  => "2014-03-13"
      }, @se.invoices)
  end

  def test_it_exists
    assert_instance_of Invoice, @iv
  end

  def test_it_returns_integer_id_of_invoice
    assert_equal 397, @iv.id
  end

  def test_it_returns_customer_id_of_invoice
    assert_equal 79, @iv.customer_id
  end

  def test_it_returns_merchant_id_of_invoice
    assert_equal 12334284, @iv.merchant_id
  end

  def test_it_returns_status_of_invoice
    assert_equal :shipped, @iv.status
  end

  def test_it_returns_instance_of_time_for_date_invoice_was_first_created
    assert_instance_of Time, @iv.created_at
  end

  def test_it_returns_instance_of_time_for_date_invoice_was_last_modified
    assert_instance_of Time, @iv.updated_at
  end

  def test_it_returns_merchant_by_merchant_id
    assert_instance_of Merchant, @iv.merchant
  end

  def test_it_returns_array_of_all_invoice_ids_by_invoice_id
    assert_instance_of Array, @iv.item_ids_by_invoice_id(397)
    assert_equal 1, @iv.item_ids_by_invoice_id(397).count
  end

  def test_items_returns_array_of_items
    assert_instance_of Array, @iv.items
    assert_instance_of Item, @iv.items.first
    assert_equal 1, @iv.items.count
  end

  def test_it_returns_array_of_transactions
    assert_instance_of Array, @iv.transactions
    assert_equal 0, @iv.transactions.count
  end

  def test_it_returns_customer_from_customer_id
    assert_instance_of Customer, @iv.customer
    assert_equal "Justyn", @iv.customer.first_name
  end

  def test_it_can_return_true_if_the_invoice_is_paid_in_full
    invoice = @se.invoices.find_by_id(26)
    assert invoice.is_paid_in_full?

    invoice = @se.invoices.find_by_id(25)
    refute invoice.is_paid_in_full?
  end

  def test_it_returns_paid_in_full_invoice_totals
    invoice = @se.invoices.find_by_id(26)
    assert_equal 18948.91, invoice.total
  end

  def test_total_method_handles_outstanding_invoice
    invoice = @se.invoices.find_by_id(25)

    assert_equal 0, invoice.total
  end

  def test_invoice_items_returns_invoice_item
    invoice = @se.invoices.find_by_id(26)

    assert_instance_of InvoiceItem, invoice.invoice_items.first
  end

  def test_pending_status_returns_true_and_false
    invoice = @se.invoices.find_by_id(25)

    assert invoice.pending?

    invoice = @se.invoices.find_by_id(1)

    refute invoice.pending?
  end

  def test_invoice_items_returns_array_of_invoice_items
    assert_instance_of Array, @iv.invoice_items
    assert_instance_of InvoiceItem, @iv.invoice_items.first
    assert_equal 1, @iv.invoice_items.count
  end
end
