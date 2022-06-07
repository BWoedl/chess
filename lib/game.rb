# frozen_string_literal: true

require_relative 'board'
require_relative 'messages'

class Game
  attr_accessor :board

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
    if board.valid_move?(piece, start_spot, end_spot)
      @board.update(piece, start_spot, end_spot, nil)
      promote(piece, piece_to_swap, end_spot) if piece.instance_of?(Pawn) && eligible_for_promotion?(piece, end_spot)
      @turn += 1
      piece.move += 1
      @board.last_piece_moved = piece
      @board.display
    else
      puts Messages::ILLEGAL_MOVE
    end
  end

  def piece_to_move
    puts "\n#{player_turn.name}" + Messages::OBTAIN_TARGET_PIECE
    input = gets.chomp
    until valid_input?(input) && own_piece?(player_turn, convert_input(input))
      puts Messages::INVALID_PIECE
      input = gets.chomp
    end
    input
  end

  def spot_to_move
    puts Messages::OBTAIN_TARGET_SPOT
    input = gets.chomp
    until valid_input?(input)
      puts Messages::INVALID_TARGET
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

  def eligible_for_promotion?(piece, end_spot)
    return true if piece.color == 'white' && end_spot[0] == 7
    return true if piece.color == 'black' && end_spot[0] == 0

    false
  end

  def piece_to_swap(selection = nil)
    pieces = [Queen, Bishop, Rook, Knight]
    puts Messages::PROMOTION_PROMPT
    input = gets.chomp.capitalize
    until pieces.to_s.include?(input)
      puts Messages::INVALID_PROMOTION_PROMPT
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
    puts Messages::GAME_END
  end
end
