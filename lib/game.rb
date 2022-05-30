# frozen_string_literal: true

require_relative 'board'

class Game
  attr_accessor :board

  INVALID_INPUT = "Try again with a valid coordinate!\n"
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

  def take_turn(legal: false)
    until legal == true
      spots = convert_to_coordinates(spot_to_move(piece_to_move))
      piece = @board.get_piece(spots[0])
      if piece.legal_move?(@board, spots[0], spots[1]) && movement?(spots[0], spots[1])
        update_board(piece, spots[0], spots[1])
        legal = true
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
    p @board.grid
    @board.grid[end_spot[0]][end_spot[1]].piece = piece
    @board.grid[start_spot[0]][start_spot[1]].piece = nil
    @board.display
  end

  def movement?(start_spot, end_spot)
    start_spot != end_spot
  end

  def piece_to_move(coordinates = [])
    puts "\n#{player_turn.name}" + OBTAIN_TARGET_PIECE
    input = gets.chomp
    until valid_input?(input)
      puts INVALID_INPUT
      input = gets.chomp
    end
    coordinates << input
  end

  def spot_to_move(coordinates)
    puts OBTAIN_TARGET_SPOT
    input = gets.chomp
    until valid_input?(input)
      puts INVALID_INPUT
      input = gets.chomp
    end
    coordinates << input
  end

  def convert_to_coordinates(input)
    columns = 'abcdefgh'
    [[input[0][1].to_i - 1, columns.index(input[0][0])], [input[1][1].to_i - 1, columns.index(input[1][0])]]
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
