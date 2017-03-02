class SalesAnalyst
  attr_reader :engine

  def initialize(engine)
    @engine = engine
  end

  def merchant_count
    engine.merchants.all.count
  end

  def item_count
    engine.items.all.count
  end

  def merchant_items_count(merchant_id)
    engine.items.find_all_by_merchant_id(merchant_id).count
  end

  def average_items_per_merchant
    (item_count / merchant_count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    total = engine.merchants.all.map do |merchant|
      ((merchant_items_count(merchant.id)) - average_items_per_merchant)**2
    end
    Math.sqrt(total.reduce(:+)/(total.length-1)).round(2)
  end

  def merchants_with_high_item_count
    std_dev = average_items_per_merchant_standard_deviation
    avg = average_items_per_merchant
    engine.merchants.all.find_all do |merchant|
      merchant_items_count(merchant.id) > (std_dev + avg)
    end
  end

  def merchant_items(merchant_id)
    engine.items.find_all_by_merchant_id(merchant_id)
  end

  def average_item_price_for_merchant(merchant_id)
    total = merchant_items(merchant_id).map do |item|
      item.unit_price
    end
    (total.reduce(:+)/total.length).round(2)
  end

  def average_average_price_per_merchant
    averages = engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (averages.reduce(:+)/averages.length).round(2)
  end

  def average_item_price
    total = engine.items.all.map do |item|
      item.unit_price
    end
    (total.reduce(:+)/total.length.to_f)
  end

  def standard_deviation_item_price
    total = engine.items.all.map do |item|
      (item.unit_price - average_item_price)**2
    end
    Math.sqrt(total.reduce(:+)/(total.length-1))
  end

  def golden_items
    std_dev = standard_deviation_item_price
    engine.items.all.find_all do |item|
      item.unit_price > (std_dev * 2)
    end
  end

  def invoices_count
    engine.invoices.all.count
  end

  def average_invoices_per_merchant
    (invoices_count/merchant_count.to_f).round(2)
  end

  def merchant_invoice_count(merchant_id)
    engine.invoices.find_all_by_merchant_id(merchant_id).count
  end

  def average_invoices_per_merchant_standard_deviation
    total = engine.merchants.all.map do |merchant|
      (merchant_invoice_count(merchant.id) - average_invoices_per_merchant)**2
    end
    Math.sqrt(total.reduce(:+)/(total.length - 1)).round(2)
  end

  def top_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    engine.merchants.all.find_all do |merchant|
      merchant_invoice_count(merchant.id) > ((std_dev * 2) + avg)
    end
  end

  def bottom_merchants_by_invoice_count
    std_dev = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    engine.merchants.all.find_all do |merchant|
      merchant_invoice_count(merchant.id) < (avg - (std_dev * 2))
    end
  end

  def invoice_day_created
    engine.invoices.all.map do |invoice|
      invoice.created_at.strftime('%A')
    end
  end

  def number_of_invoices_created_on_given_day
    invoice_day_created.inject(Hash.new(0)) do |total, day|
     total[day] += 1
     total
   end
  end

  def invoice_created_day_standard_deviation
    total = number_of_invoices_created_on_given_day.map do |day, count|
      (count - (invoices_count/7.0))**2
    end
    Math.sqrt(total.reduce(:+)/(total.length - 1)).round(2)
  end

  def top_days_by_invoice_count
    std_dev = invoice_created_day_standard_deviation
    avg = invoices_count/7.0
    result = number_of_invoices_created_on_given_day.select do |day, count|
      day if count > (std_dev + avg)
    end # written as a case
      result.keys
  end

  def invoice_statuses_count(status)
    engine.invoices.find_all_by_status(status).count
  end

  def invoice_status(status)
    ((invoice_statuses_count(status).to_f/invoices_count) * 100).round(2)
  end

  def total_revenue_by_date(date)
    invoice_date = engine.invoices.find_all_by_date(date)
    invoice_date.reduce(0) do |x, invoice|
      x + invoice.total
    end
  end

  def top_revenue_earners(x=20)
    sorted_merchs = engine.merchants.all.sort_by {|merchant| merchant.revenue}
    top_earners = sorted_merchs.last(x).reverse
  end

  def merchants_with_pending_invoices
    pending_invoices = engine.invoices.find_all_by_status(:pending)
    b = pending_invoices.map do |invoice|
      engine.merchants.find_by_id(invoice.merchant_id)
    end
    b.uniq
  end

end
