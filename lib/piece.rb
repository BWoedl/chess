class Piece
  attr_accessor :color, :defeated

  def initialize(color, defeated: false)
    @color = color
    @defeated = defeated
  end

  # this should be moved to a different class
  def occupied_by_same_color?(board, end_spot)
    target_spot_piece = board.get_piece(end_spot)
    return true if !target_spot_piece.nil? && target_spot_piece.color == color

    false
  end

  def diagonal_move?(start_spot, end_spot)
    return true if ((start_spot[0] - end_spot[0]).abs - (start_spot[1] - end_spot[1]).abs).zero?

    false
  end

  def generate_path(start_spot, end_spot, row_operator, col_operator, path = [])
    start_row = start_spot[0] + row_operator
    start_col = start_spot[1] + col_operator
    if row_operator == 0
      until start_col == end_spot[1]
        path << [start_row, start_col]
        start_row += row_operator
        start_col += col_operator
      end
    else
      until start_row == end_spot[0]
        path << [start_row, start_col]
        start_row += row_operator
        start_col += col_operator
      end
    end
    path
  end

  def intermediate_spots_open?(board, path)
    path.each do |spot|
      return false unless board.get_piece(spot).nil?
    end
    true
  end

  def get_direction(start_spot, end_spot)
    row_operator = start_spot[0] > end_spot[0] ? -1 : 1
    col_operator = start_spot[1] > end_spot[1] ? -1 : 1
    row_operator = 0 if start_spot[0] == end_spot[0]
    col_operator = 0 if start_spot[1] == end_spot[1]
    [row_operator, col_operator]
  end
end
