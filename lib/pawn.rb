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
    col_move = end_spot[1] - start_spot[1]
    return false if occupied_by_same_color?(board, end_spot)
    return true if capture?(board, start_spot, end_spot)
    return legal_first_move?(start_spot, end_spot) if move == 1
    return true if color == 'black' && col_move.zero? && row_move == -1
    return true if color == 'white' && col_move.zero? && row_move == 1
    false
  end

  def legal_first_move?(start_spot, end_spot)
    row_move = end_spot[0] - start_spot[0]
    return true if color == 'black' && start_spot[1] == end_spot[1] && row_move.between?(-2, -1)
    return true if color == 'white' && start_spot[1] == end_spot[1] && row_move.between?(1, 2)
    false
  end

  def capture?(board, start_spot, end_spot)
    return true if en_passant?(board, start_spot, end_spot)
    return false unless diagonal_move?(start_spot, end_spot) && (end_spot[0] - start_spot[0]).abs == 1
    return false if board.get_piece(end_spot).nil? || board.get_piece(end_spot).color == color 

    true
  end

  def en_passant?(board, start_spot, end_spot)
    piece_to_pass = board.get_piece(en_passant_spot(start_spot, end_spot))
    return false if piece_to_pass.nil?
    return false unless piece_to_pass.instance_of?(Pawn) && piece_to_pass.move == 2

    true
  end

  def en_passant_spot(start_spot, end_spot)
    direction = start_spot[1] > end_spot[1] ? -1 : 1
    [start_spot[0], start_spot[1] + direction]
  end
end
