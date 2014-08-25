#! /usr/bin/env ruby

# A Ruby Implementation of Connect Four
# By Leo Rudberg, made in 2014

require 'colored'
require_relative 'Board'
require_relative 'Game.rb'
require_relative 'Place.rb'
require_relative 'Player.rb'

# XXX TESTING XXX #

the_board = Board.new

puts the_board.to_s

# FIXME can't use Place::RED
me = Player.new(the_board, :red, "Leo")

me.place_piece(3)

puts the_board.to_s

him = Player.new(the_board, :blue, "Thor")

him.place_piece(5)

puts the_board.to_s

me.place_piece(5)

puts the_board.to_s


doom = Player.new(the_board, :green, "MF DOOM")

doom.place_piece(3)
puts the_board.to_s
doom.place_piece(2)
puts the_board.to_s

