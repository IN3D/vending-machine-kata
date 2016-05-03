# A vending machine object is initalized with a coin set, this tells the
# machine which coins it knows of, and what value it assigns to them.
class VendingMachine
  def initialize(coin_set, product_set)
    @coin_set = coin_set
    @product_set = product_set
    @inserted = []
    @coin_return = []
  end

  def buy(name)
    @product_set.find { |p| p[:name] == name }
  end

  def display
    'INSERT COIN'
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

  def in_set?(coin)
    included = false
    @coin_set.each { |c| included = true if !included && c[:coin] == coin }
    included
  end
end
