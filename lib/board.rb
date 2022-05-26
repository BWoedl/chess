require_relative 'spot'
require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'king'
require_relative 'queen'
require_relative 'pawn'

class Board
  attr_accessor :grid

  def initialize(grid = create_board)
    @grid = grid
    start_board
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

  def start_board
    @grid[0][0].piece, @grid[0][7].piece = Rook.new('black')
    @grid[0][1].piece, @grid[0][6].piece = Knight.new('black')
    @grid[0][2].piece, @grid[0][5].piece = Bishop.new('black')
    @grid[0][3].piece = King.new('black')
    @grid[0][3].piece = Queen.new('black')

    @grid[1][0].piece, @grid[1][1].piece = Pawn.new('black')
    @grid[1][2].piece, @grid[1][3].piece = Pawn.new('black')
    @grid[1][4].piece, @grid[1][5].piece = Pawn.new('black')
    @grid[1][6].piece, @grid[1][7].piece = Pawn.new('black')

    @grid[7][0].piece, @grid[7][7].piece = Rook.new('white')
    @grid[7][1].piece, @grid[7][6].piece = Knight.new('white')
    @grid[7][2].piece, @grid[7][5].piece = Bishop.new('white')
    @grid[7][3].piece = King.new('white')
    @grid[7][3].piece = Queen.new('white')

    @grid[6][0].piece, @grid[6][1].piece = Pawn.new('white')
    @grid[6][2].piece, @grid[6][3].piece = Pawn.new('white')
    @grid[6][4].piece, @grid[6][5].piece = Pawn.new('white')
    @grid[6][6].piece, @grid[6][7].piece = Pawn.new('white')
  end

  def display
    line = ''
    @grid.each do |row|
      row.each { |spot| line += "#{spot.x}, #{spot.y}: #{spot.piece} | "}
      line += "\n"
    end
    puts line
  end
end
