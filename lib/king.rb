class King < Piece
  attr_accessor :symbol, :move

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol 
    @move = move
  end

  def set_symbol
    color == 'white' ? '♛'.bold : '♛'.black
  end

  def legal_move?(board, start_spot, end_spot)
    return false if occupied_by_same_color?(board, end_spot)

    row_move = start_spot[0] - end_spot[0]
    col_move = start_spot[1] - end_spot[1]

    row_move.abs <= 1 && col_move.abs <= 1
  end
end
