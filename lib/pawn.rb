class Pawn < Piece
  attr_accessor :symbol, :move

  def initialize(color)
    super(color)
    @symbol = set_symbol
    @move = 1
  end

  def set_symbol
    color == 'white' ? '♟'.bold : '♟'.black
  end

  def legal_move?(board, start_spot, end_spot)
    row_move = end_spot[0] - start_spot[0]
    return true if diagonal_move?(start_spot, end_spot) && occupied_by_same_color?(board, end_spot) #and row_move.abs = 1
    return false if occupied_by_same_color?(board, end_spot)
    return legal_first_move?(board, start_spot, end_spot) if move == 1
    return true if color == 'black' && start_spot[1] == end_spot[1] && row_move == -1
    return true if color == 'white' && start_spot[1] == end_spot[1] && row_move == 1

    false
  end

  def legal_first_move?(board, start_spot, end_spot)
    row_move = end_spot[0] - start_spot[0]
    return true if color == 'black' && start_spot[1] == end_spot[1] && row_move.between?(-2, -1)
    return true if color == 'white' && start_spot[1] == end_spot[1] && row_move.between?(1, 2)

    false
  end
end
