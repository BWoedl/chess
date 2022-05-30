# frozen_string_literal: true

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

  def get_piece(spot)
    @grid[spot[0]][spot[1]].piece
  end

  def create_board(grid = [], x = 0)
    8.times do
      grid[x] = []
      y = 0
      8.times do
        grid[x] << Spot.new(x, y, nil)
        y += 1
      end
      x += 1
    end
    grid
  end

  def setup_board_pieces
    piece_types = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    piece_types.each_with_index do |type, i|
      @grid[7][i].piece = type.new('black')
      @grid[0][i].piece = type.new('white')
      @grid[6][i].piece = Pawn.new('black')
      @grid[1][i].piece = Pawn.new('white')
    end
  end

  def display
    puts `clear`
    line = "   a      b      c      d      e      f      g      h\n\n".bold
    @grid.reverse.each do |row|
      line += display_block_lines(row)
    end
    puts line
  end

  # return to this to reduce complexity

  def display_block_lines(row, line = '')
    3.times do |index|
      row.each do |spot|
        line += (spot.x.even? && spot.y.even?) || (spot.x.odd? && spot.y.odd?) ? CYAN_BG : GRAY_BG
        index == 1 && !spot.piece.nil? ? line[-8] = spot.piece.symbol : line
        index == 1 && spot.y == 7 ? line += "    #{spot.x + 1}".bold : line
      end
      line += "\n"
    end
    line
  end
end
