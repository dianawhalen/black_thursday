class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :parent

  def initialize(row, parent)
    @id = row[:id].to_i
    @name = row[:name]
    @created_at = row[:created_at]
    @updated_at = row[:updated_at]
    @parent = parent
  end

  def items
    parent.engine.items.find_all_by_merchant_id(id)
  end

  def invoices
    parent.engine.invoices.find_all_by_merchant_id(id)
  end

  def customers
    customer_ids = self.invoices.map do |invoice|
      invoice.customer_id
    end

    customer_ids.map do |customer_id|
      parent.engine.customers.find_by_id(customer_id)
    end.uniq
  end

end
