class Queen < Piece
  attr_accessor :symbol
  
  def initialize(color)
    super(color)
    @symbol = symbol
  end

  def symbol
    color == 'white' ? '♔' : '♚'
  end
end
