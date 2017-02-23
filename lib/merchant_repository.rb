class MerchantRepository
  attr_reader :all
  def initialize(path)
    # @path = path
    @all = []
    csv_loader(path)
    merchant_maker
  end

  def find_by_name(name)

  end

  def csv_loader(path)
    @csv = CSV.open(path, headers:true, header_converters: :symbol)
  end

  def merchant_maker
    @all = @csv.map do |row|
      Merchant.new(row, self)
    end
  end

end
