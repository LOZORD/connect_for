#! /usr/bin/env ruby

# A Ruby Implementation of Connect Four
# By Leo Rudberg, made in 2014

require 'colored'
require_relative 'Board'
require_relative 'Game.rb'
require_relative 'Place.rb'
require_relative 'Player.rb'

# XXX TESTING XXX #

# first set up the game
my_game = Game.new
# then play it
my_game.play
