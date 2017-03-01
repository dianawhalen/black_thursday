require 'time'

class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :parent

  def initialize(row, parent = nil)
    @id = row[:id].to_i
    @first_name = row[:first_name]
    @last_name = row[:last_name]
    @created_at = Time.parse(row[:created_at])
    @updated_at = Time.parse(row[:updated_at])
    @parent = parent
  end

  def invoices
    parent.engine.invoices.find_all_by_customer_id(id)
  end

  def merchants
    merchant_ids = self.invoices.map do |invoice|
      invoice.merchant_id
    end

    merchant_ids.map do |merchant_id|
      parent.engine.merchants.find_by_id(merchant_id)
    end.uniq
  end

end
