#! /usr/bin/env ruby

# A Ruby Implementation of Connect Four
# By Leo Rudberg, made in 2014

require 'colored'
require_relative 'board.rb'
require_relative 'game.rb'
require_relative 'place.rb'
require_relative 'player.rb'
require_relative 'ai.rb'

# XXX TESTING XXX #

# first set up the game
my_game = Game.new
# then play it
my_game.play
