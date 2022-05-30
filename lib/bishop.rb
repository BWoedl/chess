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
    return false if occupied_by_same_color?(board, end_spot)

    diagonal_move?(start_spot, end_spot)
  end

  def check_intermediate_spots(board, start_spot, end_spot)
    
  end
end
