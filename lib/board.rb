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
  attr_accessor :grid, :last_piece_moved

  CYAN_BG = '       '.bg_cyan
  GRAY_BG = '       '.bg_gray

  def initialize(grid = create_board)
    @grid = grid
    @last_piece_moved = nil
    setup_board_pieces
  end

  def get_piece(spot)
    return @grid[spot[0]][spot[1]].piece unless @grid[spot[0]][spot[1]].nil?

    nil
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
    display_block_lines
    puts "\nThe black king is in check!" if check?('black') == true
    puts "\nThe white king is in check" if check?('white') == true
  end

  # return to this to reduce complexity
  def display_block_lines
    line = "   a      b      c      d      e      f      g      h\n\n".bold
    @grid.reverse.each do |row|
      3.times do |index|
        row.each do |spot|
          line += (spot.x.even? && spot.y.even?) || (spot.x.odd? && spot.y.odd?) ? CYAN_BG : GRAY_BG
          index == 1 && !spot.piece.nil? ? line[-8] = spot.piece.symbol : line
          index == 1 && spot.y == 7 ? line += "    #{spot.x + 1}".bold : line
        end
        line += "\n"
      end
    end
    puts line
  end

  def valid_move?(piece, start_spot, end_spot)
    return false if occupied_by_same_color?(piece, end_spot)
    return false if start_spot == end_spot
    return false unless piece.legal_move?(self, start_spot, end_spot)
    return false if puts_king_in_check?(start_spot, end_spot)

    true
  end

  def occupied_by_same_color?(piece, end_spot)
    target_spot_piece = get_piece(end_spot)
    return true if !target_spot_piece.nil? && target_spot_piece.color == piece.color

    false
  end

  def puts_king_in_check?(start_spot, end_spot)
    test_board = clone_board
    piece = test_board.grid[start_spot[0]][start_spot[1]].piece
    test_board.update(piece, start_spot, end_spot)
    test_board.check?(piece.color)
  end

  def clone_board
    test_board = Board.new
    test_board.grid.flatten.map { |spot| spot.piece = nil }
    copied_spots = [active_opponent_spots('white'), active_opponent_spots('black')].flatten
    copied_spots.each { |spot| test_board.grid[spot.x][spot.y].piece = spot.piece.class.new(spot.piece.color) }
    test_board
  end

  def update(piece, start_spot, end_spot, passant_spot = nil)
    unless passant?(piece, start_spot, end_spot).nil?
      passant_spot = piece.en_passant_spot(start_spot, end_spot)
    end
    if piece.instance_of?(King) && piece.castling_move?(self, start_spot, end_spot)
      move_rook_for_castling(piece, start_spot, end_spot) 
    end
    move_piece(piece, start_spot, end_spot, passant_spot)
  end

  def move_rook_for_castling(piece, start_spot, end_spot)
    rook_spot = piece.rook_spot_for_castling(start_spot, end_spot)
    rook_end_y_spot = rook_spot[1] == 0 ? 3 : 5
    rook = get_piece(rook_spot)
    move_piece(rook, [rook_spot[0], rook_spot[1]], [rook_spot[0], rook_end_y_spot])
  end

  def move_piece(piece, start_spot, end_spot, passant_spot = nil)
    target_spot_piece = passant_spot ? get_piece(passant_spot) : get_piece(end_spot)
    defeat_piece(target_spot_piece, passant_spot) unless target_spot_piece.nil?
    @grid[start_spot[0]][start_spot[1]].piece = nil
    @grid[end_spot[0]][end_spot[1]].piece = piece
  end

  def defeat_piece(target_spot_piece, passant_spot)
    target_spot_piece.defeated = true
    @grid[passant_spot[0]][passant_spot[1]].piece = nil if passant_spot
  end

# refactor to be true / false
  def passant?(piece, start_spot, end_spot)
    if piece.instance_of?(Pawn) && piece.en_passant?(self, start_spot, end_spot)
      return piece.en_passant_spot(start_spot, end_spot)
    end

    nil
  end

  def active_opponent_spots(color)
    spots = []
    @grid.each do |row|
      row.each do |spot|
        spots << spot unless spot.piece.nil? || spot.piece.color == color
      end
    end
    spots
  end

  def check?(color)
    king_spot = find_king_spot(color)
    spots = active_opponent_spots(color)
    spots.each do |spot|
      next if spot.piece.instance_of?(King)
      return true if spot.piece.legal_move?(self, [spot.x, spot.y], [king_spot.x, king_spot.y])
    end
    false
  end

  def find_king_spot(color)
    @grid.each do |row|
      row.each do |spot|
        return spot if !spot.piece.nil? && spot.piece.instance_of?(King) && spot.piece.color == color
      end
    end
    nil
  end
end
