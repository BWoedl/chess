class Knight < Piece
  attr_accessor :symbol

  MOVES = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]

  def initialize(color)
    super(color)
    @symbol = set_symbol
  end

  def set_symbol
    color == 'white' ? '♞'.bold : '♞'.black
  end

  def self.legal_move?(start_spot, end_spot)
    MOVES.include?([end_spot[0] - start_spot[0], end_spot[1] - start_spot[1]])
  end
end
