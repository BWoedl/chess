
# frozen_string_literal: true

require 'pry-byebug'
require_relative 'lib/board'
require_relative 'lib/game'
require_relative 'lib/player'
require_relative 'lib/color'

def start_game
  puts "\nHeyo, let's play chess!".magenta
  players = create_players
  while create_new_game?
    game = Game.new(players[0], players[1])
    game.play
  end
  puts 'See you next time!'
end

def create_players
  puts "\nWhat's your name?".bold
  player1 = Player.new(gets.chomp, 1, 'white')
  puts "\nYou'll be the white pieces\n"
  puts "\nWhat's your name?".bold
  player2 = Player.new(gets.chomp, 2, 'black')
  puts "\nYou'll be the black pieces\n"
  players = [player1, player2]
end

def create_new_game?
  puts "\n\nWould you like to start a new chess game?"
  puts 'Type Y or N'.bold
  input = gets.chomp.downcase
  input == 'y'
end

start_game