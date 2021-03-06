class Rook < Piece
  attr_accessor :symbol, :move

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol
    @move = move
  end

  def moves
    [[-1, 0], [1, 0], [0, 1], [0, -1]]
  end

  def set_symbol
    color == 'white' ? '♜'.bold : '♜'.black
  end

  def legal_move?(board, start_spot, end_spot)
    operators = get_direction(start_spot, end_spot)
    path = generate_path(start_spot, end_spot, operators[0], operators[1])
    return false unless orthogonal_move?(start_spot, end_spot)
    return true if intermediate_spots_open?(board, path)

    false
  end
end
