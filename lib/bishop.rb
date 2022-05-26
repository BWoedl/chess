class Bishop < Piece
  def initialize(color)
    super(color)
    @symbol = symbol
  end

  def symbol
    color == 'white' ? '♗' : '♝'
  end
end
