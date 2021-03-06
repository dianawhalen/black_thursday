require 'time'

class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :parent

  def initialize(row, parent = nil)
    @id = row[:id].to_i
    @customer_id = row[:customer_id].to_i
    @merchant_id = row[:merchant_id].to_i
    @status = row[:status].to_sym
    @created_at = Time.parse(row[:created_at])
    @updated_at = Time.parse(row[:updated_at])
    @parent = parent
  end

  def merchant
    parent.engine.merchants.find_by_id(merchant_id)
  end

  def item_ids_by_invoice_id(invoice_id)
    parent.engine.invoice_items.find_all_by_invoice_id(invoice_id)
  end

  def items
    item_ids = item_ids_by_invoice_id(id).map do |inv_item|
      inv_item.item_id
    end
    item_ids.map do |item_id|
      parent.engine.items.find_by_id(item_id)
    end
  end

  def transactions
    parent.engine.transactions.find_all_by_invoice_id(id)
  end

  def customer
    parent.engine.customers.find_by_id(customer_id)
  end

  def is_paid_in_full?
    return false if transactions.empty?
    transactions.any? { |transaction| transaction.result == "success" }
  end

  def total
    if is_paid_in_full?
      invoice_item = parent.engine.invoice_items.find_all_by_invoice_id(id)
      invoice_item.inject(0) do |total, item|
        total += item.unit_price * item.quantity
      end
    else
      0
    end
  end

  def pending?
    status = transactions.none? {|transaction| transaction.result == "success"}
    case status
    when true
      true
    when false
      false
    end
  end

  def invoice_items
    parent.engine.invoice_items.find_all_by_invoice_id(id)
  end
end
