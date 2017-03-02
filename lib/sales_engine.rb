require 'pry'
require 'csv'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/customer_repository'
require_relative '../lib/merchant'
require_relative '../lib/item'
require_relative '../lib/invoice'
require_relative '../lib/invoice_item'
require_relative '../lib/transaction'
require_relative '../lib/customer'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(data)
    @merchants ||= MerchantRepository.new(data[:merchants], self)
    @items ||= ItemRepository.new(data[:items], self)
    @invoices ||= InvoiceRepository.new(data[:invoices], self)
    @invoice_items ||= InvoiceItemRepository.new(data[:invoice_items], self)
    @transactions ||= TransactionRepository.new(data[:transactions], self)
    @customers ||= CustomerRepository.new(data[:customers], self)
  end

  def self.from_csv(data)
    SalesEngine.new(data)
  end
end
