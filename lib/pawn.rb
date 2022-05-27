class Pawn < Piece
  attr_accessor :symbol

  def initialize(color)
    super(color)
    @symbol = set_symbol
  end

  def set_symbol
    color == 'white' ? '♟'.bold : '♟'.black
  end
end
