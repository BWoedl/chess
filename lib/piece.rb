class Piece
  attr_accessor :color, :defeated

  def initialize(color, defeated: false)
    @color = color
    @defeated = defeated
  end
end
