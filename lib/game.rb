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
    if valid_turn?(piece, start_spot, end_spot)
      update_board(@board, piece, start_spot, end_spot, nil)
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

  def valid_turn?(piece, start_spot, end_spot)
    if piece.legal_move?(@board, start_spot, end_spot) && start_spot != end_spot && !puts_king_in_check?(start_spot, end_spot)
      return true
    end

    false
  end

  def puts_king_in_check?(start_spot, end_spot)
    test_board = clone_board
    piece = test_board.grid[start_spot[0]][start_spot[1]].piece
    update_board(test_board, piece, start_spot, end_spot)
    test_board.check?(piece.color)
  end

  def clone_board
    test_board = Board.new
    test_board.grid.flatten.map { |spot| spot.piece = nil }
    copied_spots = [@board.active_opponent_spots('white'), @board.active_opponent_spots('black')].flatten
    copied_spots.each { |spot| test_board.grid[spot.x][spot.y].piece = spot.piece.class.new(spot.piece.color) }
    test_board
  end

  def update_board(board, piece, start_spot, end_spot, passant_spot = nil)
    passant_spot = passant?(board, piece, start_spot, end_spot)
    if piece.instance_of?(King) && piece.castling_move?(board, start_spot, end_spot)
      move_rook_for_castling(board, piece, start_spot, end_spot) 
    end
    move_piece(board, piece, start_spot, end_spot, passant_spot)
  end

  def passant?(board, piece, start_spot, end_spot)
    if piece.instance_of?(Pawn) && piece.en_passant?(board, start_spot, end_spot)
      return piece.en_passant_spot(start_spot, end_spot)
    end

    nil
  end

  def move_rook_for_castling(board, piece, start_spot, end_spot)
    rook_spot = piece.rook_spot_for_castling(board, start_spot, end_spot)
    rook_end_y_spot = start_spot[1] == 0 ? 3 : 5
    rook = board.get_piece(rook_spot)
    move_piece(board, rook, [rook_spot[0], rook_spot[1]], [rook_spot[0], rook_end_y_spot])
  end

  def move_piece(board, piece, start_spot, end_spot, passant_spot = nil)
    target_spot_piece = passant_spot ? board.get_piece(passant_spot) : board.get_piece(end_spot)
    defeat_piece(board, target_spot_piece, passant_spot) unless target_spot_piece.nil?
    board.grid[start_spot[0]][start_spot[1]].piece = nil
    board.grid[end_spot[0]][end_spot[1]].piece = piece
  end

  def defeat_piece(board, target_spot_piece, passant_spot)
    target_spot_piece.defeated = true
    board.grid[passant_spot[0]][passant_spot[1]].piece = nil if passant_spot
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
