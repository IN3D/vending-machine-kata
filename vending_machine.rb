# A vending machine object is initalized with a coin set, this tells the
# machine which coins it knows of, and what value it assigns to them.
class VendingMachine
  def initialize(coin_set, product_set)
    @coin_set = coin_set
    @product_set = product_set
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
    message.nil? ? 'INSERT COIN' : message
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
    @inserted.inject(0) do |sum, coin|
      sum + @coin_set.find { |c| c[:coin] == coin }[:value]
    end
  end

  private

  def alert_price_of(product)
    @messages << "PRICE $#{product[:price]}"
    nil
  end

  def in_set?(coin)
    included = false
    @coin_set.each { |c| included = true if !included && c[:coin] == coin }
    included
  end

  def purchase(product)
    @coin_return = make_change((value - product[:price]).round(2))
    @messages << 'THANK YOU'
    product
  end
end
