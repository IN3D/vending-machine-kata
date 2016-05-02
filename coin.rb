# Defines a coin, note that a coin does not assign a value to itself, other
# classes consuming a coin can decide what values they want to assign to a
# given combination of weight, diameter, and thickness. A coin is immutable
# once created.
class Coin
  attr_reader :weight, :diameter, :thickness

  def initialize(weight, diameter, thickness)
    @weight = weight
    @diameter = diameter
    @thickness = thickness
  end

  def ==(other)
    (weight == other.weight &&
     diameter == other.diameter &&
     thickness == other.thickness)
  end
end
