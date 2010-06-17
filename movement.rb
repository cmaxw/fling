class Movement
  attr_accessor :x, :y, :direction
  
  def initialize(x, y, direction)
    @x = x
    @y = y
    @direction = direction
  end
  
  def to_s
    "(#{x}, #{y}) #{direction}"
  end
end