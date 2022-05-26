require_relative 'spot'

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
    @grid[0][0].piece, @grid[0][7].piece = "rook"
    @grid[0][1].piece, @grid[0][6].piece = "knight"
    @grid[0][2].piece, @grid[0][5].piece = "bishop"
    @grid[0][3].piece = "king"
    @grid[0][3].piece = "queen"

    @grid[7][0].piece, @grid[7][7].piece = "rook"
    @grid[7][1].piece, @grid[7][6].piece = "knight"
    @grid[7][2].piece, @grid[7][5].piece = "bishop"
    @grid[7][3].piece = "king"
    @grid[7][3].piece = "queen"

    @grid[1][0].piece, @grid[1][1].piece = "pawn"
    @grid[1][2].piece, @grid[1][3].piece = "pawn"
    @grid[1][4].piece, @grid[1][5].piece = "pawn"
    @grid[1][6].piece, @grid[1][7].piece = "pawn"
    @grid[6][0].piece, @grid[6][1].piece = "pawn"
    @grid[6][2].piece, @grid[6][3].piece = "pawn"
    @grid[6][4].piece, @grid[6][5].piece = "pawn"
    @grid[6][6].piece, @grid[6][7].piece = "pawn"
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
