require_relative '../coin'
require_relative '../vending_machine'

describe 'A Vending Machine' do
  before(:each) do
    @penny = Coin.new(2.5, 0.75, 1.52)
    @nickel = Coin.new(5.0, 0.84, 1.95)
    @dime = Coin.new(2.3, 0.71, 1.35)
    @quarter = Coin.new(5.7, 0.96, 1.75)
    @coin_set = [
      { coin: @nickel, value: 0.05 },
      { coin: @dime, value: 0.10 },
      { coin: @quarter, value: 0.25 }
    ]
    @product_set = [
      { name: 'cola', price: 1.0 },
      { name: 'chips', price: 0.5 },
      { name: 'candy', price: 0.65 }
    ]
  end

  it 'should display "INSERT COIN" when the machine is empty' do
    vending_machine = VendingMachine.new(@coin_set, nil)
    expect(vending_machine.display).to eq('INSERT COIN')
  end

  it 'should accept coins' do
    vending_machine = VendingMachine.new(@coin_set, nil)
    result = vending_machine.insert(@nickel)
    expect(result).to eq [@nickel]
  end

  it 'should put invalid coins into the coin return' do
    vending_machine = VendingMachine.new(@coin_set, nil)
    vending_machine.insert(@penny)
    returned = vending_machine.coin_return
    expect(returned).to eq [@penny]
  end

  it "should show the user the amount they've entered on request" do
    vending_machine = VendingMachine.new(@coin_set, nil)
    vending_machine.insert(@nickel)
    expect(vending_machine.value).to eq 0.05
  end

  it 'should return nil if there are no products' do
    vending_machine = VendingMachine.new(@coin_set, [])
    bought = vending_machine.buy('cola')
    expect(bought).to eq nil
  end

  it 'should return a product if it is found' do
    vending_machine = VendingMachine.new(@coin_set, @product_set)
    bought = vending_machine.buy('cola')
    expect(bought).to eq @product_set[0]
  end
end
