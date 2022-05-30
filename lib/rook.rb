class Rook < Piece
  attr_accessor :symbol, :move

  def initialize(color)
    super(color)
    @symbol = set_symbol
    @move = 1
  end

  def set_symbol
    color == 'white' ? '♜'.bold : '♜'.black
  end

  def legal_move?(board, start_spot, end_spot)
    return false if occupied_by_same_color?(board, end_spot)

    row_move = start_spot[0] - end_spot[0]
    col_move = start_spot[1] - end_spot[1]

    if col_move.zero?
      return true if check_intermediate_row_spots(board, start_spot[0], end_spot[0])
    elsif row_move.zero?
      return true if check_intermediate_col_spots(board, start_spot[1], end_spot[1])
    else
      false
    end
  end

  # see if following two methods can be combined / abstracted 
  def check_intermediate_row_spots(board, start_spot, end_spot)
    (min(start_spot, end_spot)...max(start_spot, end_spot)).each do |spot|
      return false unless board.get_piece([spot, start_spot]).nil?
    end
    true
  end

  def check_intermediate_col_spots(board, start_spot, end_spot)
    (min(start_spot, end_spot)...max(start_spot, end_spot)).each do |spot|
      return false unless board.get_piece([start_spot[0], spot]).nil?
    end
    true
  end

  def min(start_spot, end_spot)
    [start_spot, end_spot].min
  end

  def max(start_spot, end_spot)
    [start_spot, end_spot].max
  end
end
