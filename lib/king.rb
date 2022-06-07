class King < Piece
  attr_accessor :symbol, :move

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol
    @move = move
  end

  def set_symbol
    color == 'white' ? '♚'.bold : '♚'.black
  end

  def legal_move?(board, start_spot, end_spot)
    row_move = start_spot[0] - end_spot[0]
    col_move = start_spot[1] - end_spot[1]
    return true if castling_move?(board, start_spot, end_spot)
    return true if row_move.abs <= 1 && col_move.abs <= 1

    false
  end

  def castling_move?(board, start_spot, end_spot)
    rook = board.get_piece(rook_spot_for_castling(start_spot, end_spot))
    row = color == 'white' ? 0 : 7
    return false if move > 1 || rook.move > 1 || board.check?(color)

    if end_spot == [row, 2]
      path = [[row, 1], [row, 2], [row, 3]]
      return true if path.all? { |spot| spot.piece.nil? }
    elsif end_spot == [row, 6]
      path = [[row, 5], [row, 6]]
      return true if path.all? { |spot| board.get_piece(spot).nil? }
    end
    false
  end

  def rook_spot_for_castling(start_spot, end_spot)
    rook_side = end_spot[1] == 2 ? 0 : 7
    [start_spot[0], rook_side]
  end
end
