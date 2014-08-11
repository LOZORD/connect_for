# A Ruby Implementation of Connect Four
# By Leo Rudberg, made in 2014

require "colored"

MAX_NUM_PLAYERS = 4

class Board
  attr_accessor :width
  attr_accessor :height
  attr_accessor :board

  def initialize (w = 20, h = 20)
    @width = w
    @height = h
    @board = Array.new(w) { Array.new (h) { Place.new } }
  end

  def in_bounds?(x, y)
    x.between?(0...@width) && y.between?(0...@height)
  end

  def to_s
    ret = ">\n"
    ret += '.'
    ret += num_line
    ret += ".\n"
    (0...@width).each do |i|
      ret += '|'
      (0...@height).each do |j|
        ret += ( ' ' + @board[j][i].to_s + ' ' )
      end
      ret += "|\n"
    end
    ret += '.'
    ret += num_line
    ret += ".\n<\n\n"
    return ret
  end

  def [] (num)
    @board[num]
  end

  # TODO improve so the numbers match with the columns
  def num_line
    (1..@width).to_a.join(" ")
  end
end

class Player
  attr_accessor :color
  attr_accessor :name
  attr_accessor :num_pieces
  attr_accessor :board

  def initialize (some_board, some_color, some_name)
    if some_color == Place::EMPTY
      puts 'You can\'t do that!' # TODO make error
      return false
    end
    @board = some_board
    @color = some_color.to_sym
    @name = some_name.to_s
    @num_pieces = 10 # XXX hardcoded
  end

  def place_piece (col)
    col = col - 1 # convert human 1-indexing to computer 0-indexing

    # first check that the column is in bounds
    if col < 0 || col >= board.width
      puts 'Out of bounds!'
      return false
    end

    # then check if we can place any pieces in that column
    if @board[col][0].full?
      puts 'This column is already full!' #TODO make error
      return false
    end


    @board[col].reverse_each do |place|
      if place.empty?
        place.place_type = @color
        #place = Place.new(@color) FIXME is this more correct?
        return true
      end
    end

    false
  end
end

class Place
  EMPTY = :empty
  RED = :red
  BLUE = :blue
  GREEN = :green
  YELLOW = :yellow

  attr_accessor :place_type
  # x and y coord attrs?

  def initialize (type = EMPTY)
    @place_type = type
  end

  def empty?
    @place_type == EMPTY
  end

  def full?
    !empty?
  end

  def belongs_to_player?(some_player)
    @place_type == some_player.color
  end

  def to_s
    case @place_type
      when RED
        return "R".red
      when BLUE
        return "B".blue
      when GREEN
        return "G".green
      when YELLOW
        return "Y".yellow
      else
        return "_".white
    end
  end
end

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

