class Bishop < Piece
  attr_accessor :symbol, :move

  def initialize(color)
    super(color)
    @symbol = set_symbol
    @move = 1
  end

  def set_symbol
    color == 'white' ? '♝'.bold : '♝'.black
  end

  def legal_move?(board, start_spot, end_spot)
    operators = get_direction(start_spot, end_spot)
    path = generate_path(start_spot, end_spot, operators[0], operators[1])
    return false if occupied_by_same_color?(board, end_spot)
    return true if diagonal_move?(start_spot, end_spot) && intermediate_spots_open?(board, path)

    false
  end

  def get_direction(start_spot, end_spot)
    start_row = start_spot[0] > end_spot[0] ? -1 : 1
    start_col = start_spot[1] > end_spot[1] ? -1 : 1
    [start_row, start_col]
  end

  def generate_path(start_spot, end_spot, row_operator, col_operator, path = [])
    start_row = start_spot[0] + row_operator
    start_col = start_spot[1] + col_operator
    until start_row == end_spot[0]
      path << [start_row, start_col]
      start_row += row_operator
      start_col += col_operator
    end
    path
  end

  def intermediate_spots_open?(board, path)
    path.each do |spot|
      return false unless board.get_piece(spot).nil?
    end
    true
  end
end
