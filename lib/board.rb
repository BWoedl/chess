require_relative 'spot'
require_relative 'color'
require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'king'
require_relative 'queen'
require_relative 'pawn'

class Board
  attr_accessor :grid
  CYAN_BG = '       '.bg_cyan
  GRAY_BG = '       '.bg_gray

  def initialize(grid = create_board)
    @grid = grid
    setup_board_pieces
  end

  def create_board
    grid = []
    y = 0
    8.times do
      grid[y] = []
      x = 0
      8.times do
        grid[y] << Spot.new(x, y, nil)
        x += 1
      end
      y += 1
    end
    grid
  end

  def setup_board_pieces
    piece_types = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]

    piece_types.each_with_index do |type, i|
      @grid[0][i].piece = type.new('black')
      @grid[7][i].piece = type.new('white')
      @grid[1][i].piece = Pawn.new('black')
      @grid[6][i].piece = Pawn.new('white')
    end
  end

  def display
    puts `clear`
    line = "   a      b      c      d      e      f      g      h\n\n".bold
    @grid.each_with_index do |row, index|
      # line += "  #{index}  "
      line += display_block(row)
    end
    puts line
  end

  def display_block(row)
    line = ''
    3.times do |index|
      row.each do |spot|
        line += (spot.x.even? && spot.y.even?) || (spot.x.odd? && spot.y.odd?) ? CYAN_BG : GRAY_BG
        if index == 1
          spot.piece.nil? ? line : line[-8] = spot.piece.symbol
        end
      end
      line += "\n"
    end
    line
  end

  # def display_symbol(spot, line)
  #   spot.piece.nil? ? line : line[-8] = spot.piece.symbol
  # end
end
