class Queen < Piece
  attr_accessor :symbol

  def initialize(color)
    super(color)
    @symbol = set_symbol
  end

  def set_symbol
    color == 'white' ? '♚'.bold : '♚'.black
  end

  def self.legal_move?(start_spot, end_spot)
    return true if start_spot[0] == end_spot[0] || start_spot[1] == end_spot[1]
    return true if ((start_spot[0] - end_spot[0]).abs - (start_spot[1] - end_spot[1]).abs).zero?

    false
  end
end
