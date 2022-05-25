require_relative 'spot'

class Board
  attr_accessor :spots

  def initialize(grid = create_board)
    @grid = grid
  end

  def create_board
    grid = []
    x = 0
    8.times do
      y = 0
      8.times do
        grid << Spot.new(x, y, nil)
        y += 1
      end
      x += 1
    end
    grid
  end

  def display
    line = ''
    @grid.each do |row|
      line += "#{row.x}, #{row.y}\n"
    end
    puts line
  end
end
