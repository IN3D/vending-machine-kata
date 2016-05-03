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
      { name: 'cola', price: 1.0, amount: 5 },
      { name: 'chips', price: 0.5, amount: 0 },
      { name: 'candy', price: 0.65, amount: 1 }
    ]
    @bank = [
      Array.new(5) { |_| @quarter },
      Array.new(10) { |_| @dime },
      Array.new(15) { |_| @nickel }
    ].flatten!
  end

  describe 'when inserting money' do
    before(:each) do
      @vending_machine = VendingMachine.new(@coin_set, nil, @bank)
    end

    it 'should display "INSERT COIN" when the machine is empty' do
      expect(@vending_machine.display).to eq('INSERT COIN')
    end

    it 'should accept a coin' do
      expect(@vending_machine.insert(@nickel)).to eq nil
      expect(@vending_machine.return_inserted).to eq [@nickel]
    end

    it 'should accept multiple coins' do
      expect(@vending_machine.insert(@dime, @dime, @quarter)).to eq nil
      expect(@vending_machine.return_inserted).to eq [@dime, @dime, @quarter]
    end

    it 'should put invalid coins into the coin return' do
      @vending_machine.insert(@penny)
      expect(@vending_machine.coin_return).to eq [@penny]
    end

    it "should show the user the amount they've entered on request" do
      @vending_machine.insert(@nickel)
      expect(@vending_machine.value).to eq 0.05
    end
  end

  describe 'when buying an item' do
    before(:each) do
      @vending_machine = VendingMachine.new(@coin_set, @product_set, @bank)
    end

    it 'should return nil if there are no products' do
      expect(@vending_machine.buy('cola')).to eq nil
    end

    it 'should return nil if requesting a non-existant product' do
      @vending_machine.insert(@quarter, @quarter, @quarter, @quarter)
      expect(@vending_machine.buy('widget')).to eq nil
      expect(@vending_machine.display).to eq 'INSERT COIN'
    end

    it 'should return a product if enough money has been entered' do
      @vending_machine.insert(@quarter, @quarter, @quarter, @quarter)
      expect(@vending_machine.buy('cola')).to eq @product_set[0]
      expect(@vending_machine.display).to eq 'THANK YOU'
      expect(@vending_machine.display).to eq 'INSERT COIN'
    end

    it 'should show the price if enough money has not been entered' do
      @vending_machine.insert(@quarter)
      expect(@vending_machine.buy('cola')).to eq nil
      expect(@vending_machine.display).to eq 'PRICE $1.0'
      expect(@vending_machine.display).to eq 'INSERT COIN'
    end

    it 'should return nil when the selected item is out, and say "SOLD OUT"' do
      @vending_machine.insert(@quarter, @quarter)
      expect(@vending_machine.buy('chips')).to eq nil
      expect(@vending_machine.display).to eq 'SOLD OUT'
      expect(@vending_machine.display).to eq 'INSERT COIN'
    end

    it 'should not be able to get the money back that was just spent' do
      @vending_machine.insert(@quarter, @quarter, @quarter, @quarter)
      expect(@vending_machine.buy('cola')).to eq @product_set[0]
      expect(@vending_machine.return_inserted).to eq []
    end
  end

  describe 'when making change' do
    before(:each) do
      @vending_machine = VendingMachine.new(@coin_set, @product_set, @bank)
    end

    it 'should alert the user they need exact change' do
      vending_machine = VendingMachine.new(@coin_set, @product_set, nil)
      expect(vending_machine.display).to eq 'EXACT CHANGE ONLY'
    end

    it 'should return coins when more were entered than needed' do
      @vending_machine.insert(@quarter, @quarter, @quarter)
      expect(@vending_machine.buy('candy')).to eq @product_set[2]
      expect(@vending_machine.coin_return).to eq [@dime]
      expect(@vending_machine.display).to eq 'THANK YOU'
      expect(@vending_machine.display).to eq 'INSERT COIN'
    end

    it "should have more coins in it's bank after a purchase" do
      banked = @vending_machine.banked
      @vending_machine.insert(@quarter, @quarter, @quarter, @quarter)
      expect(@vending_machine.buy('cola')).to eq @product_set[0]
      expect(banked).to be < @vending_machine.banked
      expect(@vending_machine.banked - banked).to eq 1.0
    end

    it 'should return nickels if there are no dimes in the bank' do
      bank = Array.new(2) { |_| @nickel }
      vending_machine = VendingMachine.new(@coin_set, @product_set, bank)
      vending_machine.insert(@quarter, @quarter, @quarter)
      expect(vending_machine.buy('candy')).to eq @product_set[2]
      expect(vending_machine.coin_return).to eq [@nickel, @nickel]
      expect(vending_machine.banked).to eq 0.75
    end
  end
end
