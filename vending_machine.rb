# Write me
class VendingMachine
  def initialize(coin_set)
    @coin_set = coin_set
    @coin_return = []
  end

  def display
    'INSERT COIN'
  end

  def insert(coin)
    if @coin_set.include? coin
      @inserted << coin
    else
      @coin_return << coin
    end
  end

  def coin_return
    @coin_return.pop(@coin_return.length)
  end
end
