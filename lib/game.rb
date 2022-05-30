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

  def take_turn(valid: false)
    until valid == true
      start_spot = convert_input(piece_to_move)
      end_spot = convert_input(spot_to_move)
      piece = @board.get_piece(start_spot)
      if valid_turn?(piece, start_spot, end_spot)
        update_board(piece, start_spot, end_spot)
        valid = true
      else
        puts ILLEGAL_MOVE
      end
    end
  end

  def update_board(piece, start_spot, end_spot)
    @turn += 1
    piece.move += 1
    target_spot_piece = @board.get_piece(end_spot)
    target_spot_piece.defeated = true unless target_spot_piece.nil?
    @board.grid[end_spot[0]][end_spot[1]].piece = piece
    @board.grid[start_spot[0]][start_spot[1]].piece = nil
    @board.display
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

  def valid_turn?(piece, start_spot, end_spot)
    piece.legal_move?(@board, start_spot, end_spot) && start_spot != end_spot
  end

  def own_piece?(player, start_spot)
    return false if @board.get_piece(start_spot).nil?
    return true if player.color == @board.get_piece(start_spot).color
  end

  def convert_input(input)
    columns = 'abcdefgh'
    [input[1].to_i - 1, columns.index(input[0])]
  end

  def valid_input?(input)
    return false if input[0] && input[1].nil?

    return true if input[0].match(/[abcdefgh]/i) && input[1].match(/[12345678]/)

    false
  end

  def game_over?
    false
  end

  def game_end
    puts GAME_END
  end
end
