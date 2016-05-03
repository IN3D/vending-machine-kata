# A vending machine is created with a coin set, a product set and a bank.
# The coin set informs the vending machine of what coins it accepts, and what
# value it assigns to those coins.
# A product set tells the vending machine which products it has, what it charges
# for them, and how many of them are in the machine.
# The bank will pre-fill the machine with change.
class VendingMachine
  def initialize(coin_set, product_set, bank)
    @bank = bank.is_a?(Array) ? bank : []
    @coin_set = coin_set.is_a?(Array) ? coin_set : []
    @product_set = product_set.is_a?(Array) ? product_set : []
    @inserted = []
    @coin_return = []
    @messages = []
  end

  def buy(name)
    product = @product_set.find { |p| p[:name] == name }
    return if product.nil?
    value >= product[:price] ? purchase(product) : alert_price_of(product)
  end

  def display
    message = @messages.pop
    default = banked == 0 ? 'EXACT CHANGE ONLY' : 'INSERT COIN'
    message.nil? ? default : message
  end

  def make_change(amount)
    coins = []
    @coin_set.each do |c|
      num = (amount / c[:value]).floor
      Array.new(num).each { |_| coins << c[:coin] }
      amount -= c[:value] * num
    end
    coins
  end

  def insert(*coins)
    coins.each { |c| in_set?(c) ? @inserted << c : @coin_return << c }
    nil
  end

  def coin_return
    @coin_return.pop(@coin_return.length)
  end

  def return_inserted
    @inserted.pop(@inserted.length)
  end

  def value
    value_of @inserted
  end

  private

  def alert_price_of(product)
    @messages << "PRICE $#{product[:price]}"
    nil
  end

  def banked
    value_of @bank
  end

  def in_set?(coin)
    included = false
    @coin_set.each { |c| included = true if !included && c[:coin] == coin }
    included
  end

  def purchase(product)
    if product[:amount] > 0
      @coin_return = make_change((value - product[:price]).round(2))
      @messages << 'THANK YOU'
      @bank << return_inserted
      @bank.flatten!
      product
    else
      @messages << 'SOLD OUT'
      nil
    end
  end

  def value_of(arr)
    arr.inject(0) do |sum, coin|
      sum + @coin_set.find { |c| c[:coin] == coin }[:value]
    end
  end
end
