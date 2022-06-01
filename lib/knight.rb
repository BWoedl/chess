class Knight < Piece
  attr_accessor :symbol, :move

  MOVES = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol
    @move = move
  end

  def set_symbol
    color == 'white' ? '♞'.bold : '♞'.black
  end

  def legal_move?(board, start_spot, end_spot)
    return false if occupied_by_same_color?(board, end_spot)
    return true if MOVES.include?([end_spot[0] - start_spot[0], end_spot[1] - start_spot[1]])

    false
  end
end
