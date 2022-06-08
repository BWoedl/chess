class Knight < Piece
  attr_accessor :symbol, :move

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol
    @move = move
  end

  def moves
    [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
  end

  def set_symbol
    color == 'white' ? '♞'.bold : '♞'.black
  end

  def legal_move?(board, start_spot, end_spot)
    return true if moves.include?([end_spot[0] - start_spot[0], end_spot[1] - start_spot[1]])

    false
  end
end
