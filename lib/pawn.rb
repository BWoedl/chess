class Pawn < Piece
  attr_accessor :symbol, :move

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol
    @move = move
  end

  def set_symbol
    color == 'white' ? '♟'.bold : '♟'.black
  end

  def legal_move?(board, start_spot, end_spot)
    allowed_row_move = color == 'white' ? 1 : -1
    return true if en_passant?(board, start_spot, end_spot)
    return true if capture?(board, start_spot, end_spot)
    return false if board.occupied?(end_spot)
    return true if move == 1 && legal_first_move?(start_spot, end_spot)
    return true if (end_spot[1] - start_spot[1]).zero? && (end_spot[0] - start_spot[0]) == allowed_row_move

    false
  end

  def legal_first_move?(start_spot, end_spot)
    row_move = end_spot[0] - start_spot[0]
    return true if color == 'black' && start_spot[1] == end_spot[1] && row_move.between?(-2, -1)
    return true if color == 'white' && start_spot[1] == end_spot[1] && row_move.between?(1, 2)

    false
  end

  def capture?(board, start_spot, end_spot)
    return false unless board.occupied?(end_spot)
    return true if diagonal_move?(start_spot, end_spot) && (end_spot[0] - start_spot[0]).abs == 1

    false
  end

  def en_passant?(board, start_spot, end_spot)
    piece_to_pass = board.get_piece(en_passant_spot(start_spot, end_spot))
    return false if piece_to_pass.nil? || board.occupied?(end_spot)
    return false unless piece_to_pass.instance_of?(Pawn) && piece_to_pass.move == 2 && piece_to_pass.color != color
    return true if board.last_piece_moved == piece_to_pass && diagonal_move?(start_spot, end_spot) && (end_spot[0] - start_spot[0]).abs == 1

    false
  end

  def en_passant_spot(start_spot, end_spot)
    direction = start_spot[1] > end_spot[1] ? -1 : 1
    [start_spot[0], start_spot[1] + direction]
  end
end
