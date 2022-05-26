require_relative 'color'

class Rook < Piece
  attr_accessor :symbol

  def initialize(color)
    super(color)
    @symbol = symbol
  end

  def symbol
    color == 'white' ? '♜' : '♜'.black
  end
end

#♖
