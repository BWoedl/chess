class Bishop < Piece
  attr_accessor :symbol, :move

MOVES = [[1, 1], [-1, 1], [1, -1], [-1, -1]]

  def initialize(color, move = 1)
    super(color)
    @symbol = set_symbol
    @move = move
  end

  def set_symbol
    color == 'white' ? '♝'.bold : '♝'.black
  end

  def legal_move?(board, start_spot, end_spot)
    operators = get_direction(start_spot, end_spot)
    path = generate_path(start_spot, end_spot, operators[0], operators[1])
    return false unless diagonal_move?(start_spot, end_spot)
    return true if intermediate_spots_open?(board, path)

    false
  end

  def generate_possible_moves(board, start_spot)
    possibilities = []
    MOVES.each do |move|
      operators = move
      while (start_spot[0] - move[0]).between?(0, 7) && (start_spot[1] - move[1]).between?(0, 7) && board.valid_move?(self, start_spot, [(start_spot[0] - move[0]), (start_spot[1] - move[1])])
        possibilities << [(start_spot[0] - move[0]), (start_spot[1] - move[1])]
        move[0] += operators[0]
        move[1] += operators[1]
      end
    end
    possibilities
  end
end
