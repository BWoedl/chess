# frozen_string_literal: true

require_relative 'board'

class Game
  attr_accessor :board

  INVALID_PIECE = "Try again with a valid position! Select one of your pieces only\n"
  INVALID_TARGET = "Try again with a valid position! It must be on the board\n"
  OBTAIN_TARGET_SPOT = "\nNow put the column and row of the spot you'd like to move to. Ex: b4"
  ILLEGAL_MOVE = "That's an illegal move for your piece. Try again!"
  GAME_END = "Game over! "
  OBTAIN_TARGET_PIECE = ", please put the column and row of the piece you'd like to move. Ex: a4"
  CHECK = "king is now in check"

  def initialize(player1, player2, board = Board.new)
    @board = board
    @turn = 1
    @player1 = player1
    @player2 = player2
  end

  def player_turn
    @turn.odd? ? @player1 : @player2
  end

  def play
    @board.display
    take_turn until game_over?
    game_end
  end

  def take_turn
    start_spot = convert_input(piece_to_move)
    end_spot = convert_input(spot_to_move)
    piece = @board.get_piece(start_spot)
    if valid_turn?(piece, start_spot, end_spot)
      update_board(piece, start_spot, end_spot)
    else
      puts ILLEGAL_MOVE
    end
  end

  def piece_to_move
    puts "\n#{player_turn.name}" + OBTAIN_TARGET_PIECE
    input = gets.chomp
    until valid_input?(input) && own_piece?(player_turn, convert_input(input))
      puts INVALID_PIECE
      input = gets.chomp
    end
    input
  end

  def spot_to_move
    puts OBTAIN_TARGET_SPOT
    input = gets.chomp
    until valid_input?(input)
      puts INVALID_TARGET
      input = gets.chomp
    end
    input
  end

  def convert_input(input)
    columns = 'abcdefgh'
    [input[1].to_i - 1, columns.index(input[0])]
  end

  def valid_input?(input)
    return false unless input.length == 2
    return true if input[0].match(/[abcdefgh]/i) && input[1].match(/[12345678]/)

    false
  end

  def own_piece?(player, start_spot)
    return false if @board.get_piece(start_spot).nil?
    return true if player.color == @board.get_piece(start_spot).color

    false
  end

  def valid_turn?(piece, start_spot, end_spot)
    piece.legal_move?(@board, start_spot, end_spot) && start_spot != end_spot
  end

  def update_board(piece, start_spot, end_spot, passant_spot)
    @turn += 1
    piece.move += 1
    passant_spot = passant?(piece, start_spot, end_spot)
    move_piece(piece, start_spot, end_spot, passant_spot)
    promote(piece, piece_to_swap, end_spot) if piece.instance_of?(Pawn) && eligible_for_promotion?(piece, end_spot)
    @board.display
  end

  def passant?(piece, start_spot, end_spot)
    if piece.instance_of?(Pawn) && piece.en_passant?(@board, start_spot, end_spot)
      return piece.en_passant_spot(start_spot, end_spot)
    end

    nil
  end

  def move_piece(piece, start_spot, end_spot, passant_spot = nil)
    target_spot_piece = passant_spot ? @board.get_piece(passant_spot) : @board.get_piece(end_spot)
    defeat_piece(target_spot_piece, passant_spot) unless target_spot_piece.nil?
    @board.grid[start_spot[0]][start_spot[1]].piece = nil
    @board.grid[end_spot[0]][end_spot[1]].piece = piece
  end

  def defeat_piece(target_spot_piece, passant_spot)
    target_spot_piece.defeated = true
    @board.grid[passant_spot[0]][passant_spot[1]].piece = nil if passant_spot
  end

  def eligible_for_promotion?(piece, end_spot)
    return true if piece.color == 'white' && end_spot[0] == 7
    return true if piece.color == 'black' && end_spot[0] == 0

    false
  end

  def piece_to_swap(selection = nil)
    pieces = [Queen, Bishop, Rook, Knight]
    puts 'Which piece would you like to swap your pawn for? Type Queen, Bishop, Rook, or Knight'
    input = gets.chomp.capitalize
    until pieces.to_s.include?(input)
      puts "That's not a valid option! Which piece would you like to swap your pawn for? Type Queen, Bishop, Rook, or Knight"
      input = gets.chomp.capitalize
    end
    pieces.each { |piece| selection = piece if piece.to_s.match(input) }
    selection
  end

  def promote(piece, piece_to_swap, end_spot)
    @board.grid[end_spot[0]][end_spot[1]].piece = piece_to_swap.new(piece.color, piece.move)
  end

  def game_over?
    false
  end

  def game_end
    puts GAME_END
  end
end
