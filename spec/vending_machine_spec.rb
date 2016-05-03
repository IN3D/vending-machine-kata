require_relative '../coin'
require_relative '../vending_machine'

describe 'A Vending Machine' do
  before(:each) do
    @penny = Coin.new(2.5, 0.75, 1.52)
    @nickel = Coin.new(5.0, 0.84, 1.95)
    @dime = Coin.new(2.3, 0.71, 1.35)
    @quarter = Coin.new(5.7, 0.96, 1.75)
    @coin_set = [
      { coin: @quarter, value: 0.25 },
      { coin: @dime, value: 0.10 },
      { coin: @nickel, value: 0.05 }
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

  it 'should accept a coin' do
    vending_machine = VendingMachine.new(@coin_set, nil)
    result = vending_machine.insert(@nickel)
    returned = vending_machine.return_inserted
    expect(result).to eq nil
    expect(returned).to eq [@nickel]
  end

  it 'should accept multiple coins' do
    vending_machine = VendingMachine.new(@coin_set, nil)
    result = vending_machine.insert(@dime, @dime, @quarter)
    returned = vending_machine.return_inserted
    expect(result).to eq nil
    expect(returned).to eq [@dime, @dime, @quarter]
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

  it 'should return nil if requesting a non-existant product' do
    vending_machine = VendingMachine.new(@coin_set, @product_set)
    vending_machine.insert(@quarter, @quarter, @quarter, @quarter)
    bought = vending_machine.buy('widget')
    expect(bought).to eq nil
    expect(vending_machine.display).to eq 'INSERT COIN'
  end

  it 'should return a product if enough money has been entered' do
    vending_machine = VendingMachine.new(@coin_set, @product_set)
    vending_machine.insert(@quarter, @quarter, @quarter, @quarter)
    bought = vending_machine.buy('cola')
    expect(bought).to eq @product_set[0]
    expect(vending_machine.display).to eq 'THANK YOU'
    expect(vending_machine.display).to eq 'INSERT COIN'
  end

  it 'should show the price if enough money has not been entered' do
    vending_machine = VendingMachine.new(@coin_set, @product_set)
    vending_machine.insert(@quarter)
    bought = vending_machine.buy('cola')
    expect(bought).to eq nil
    expect(vending_machine.display).to eq 'PRICE $1.0'
    expect(vending_machine.display).to eq 'INSERT COIN'
  end

  it 'should return coins when more were entered than needed' do
    vending_machine = VendingMachine.new(@coin_set, @product_set)
    vending_machine.insert(@quarter, @quarter, @quarter)
    bought = vending_machine.buy('candy')
    expect(bought).to eq @product_set[2]
    expect(vending_machine.coin_return).to eq [@dime]
    expect(vending_machine.display).to eq 'THANK YOU'
    expect(vending_machine.display).to eq 'INSERT COIN'
  end
end
