require_relative '../coin'

describe 'A coin' do
  before(:each) do
    @weight = 5.0
    @diameter = 0.84
    @thickness = 1.95
    @coin = Coin.new(@weight, @diameter, @thickness)
  end

  it 'should have a weight, diameter, and thickness' do
    expect(@coin.weight).to eq 5.0
    expect(@coin.diameter).to eq 0.84
    expect(@coin.thickness).to eq 1.95
  end

  it 'should have immutable attributes' do
    expect { @coin.weight = 1.0 } .to raise_error(NoMethodError)
  end

  it 'should be equal if compared to an identical coin' do
    expect(@coin == Coin.new(@weight, @diameter, @thickness)).to eq true
  end

  it 'should be unequal if another coin has a different weight' do
    expect(@coin == Coin.new(2.0, @diameter, @thickness)).to eq false
  end

  it 'should be uneqaul if another coin has a different diameter' do
    expect(@coin == Coin.new(@weight, 0.20, @thickness)).to eq false
  end

  it 'should be uneqaul if another coin has a different thickness' do
    expect(@coin == Coin.new(@weight, @diameter, 1.20)).to eq false
  end
end
