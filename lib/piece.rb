class Piece
  attr_accessor :color, :defeated

  def initialize(color, defeated: false)
    @color = color
    @defeated = defeated
  end

  def occupied_by_same_color?(board, end_spot)
    target_spot_piece = board.get_piece(end_spot)
    return true if !target_spot_piece.nil? && target_spot_piece.color == color
  end

  def diagonal_move?(start_spot, end_spot)
    return true if ((start_spot[0] - end_spot[0]).abs - (start_spot[1] - end_spot[1]).abs).zero?

    false
  end
end
