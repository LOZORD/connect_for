# This class implements a Board of pieces for playing Connect Four
class Board
  attr_reader :width
  attr_reader :height
  attr_accessor :board
  attr_reader :game

  def initialize(g, w = 7, h = 6)
    @game = g
    @width = w
    @height = h
    # normal Cartesian grid with (0,0) being SW corner
    @board = Array.new(w) { |x| Array.new(h) { |y| Place.new(x, h - y - 1) } }
  end

  def in_bounds?(x, y)
    x.between?(0, width - 1) && y.between?(0, height - 1)
    # place_at(x,y).nil?
  end

  def at(x, y)
    @board[x][- y - 1]
  end

  def column(n)
    @board[n]
  end

  def top_of_col(col_num = nil)
    if !col_num.nil?
      place_at(col_num, height - 1)
    else
      height - 1
    end
  end

  alias_method :place_at, :at

  def to_s
    ret = ">\n##{ num_line }#\n"
    height.times do |y|
      ret += '|'
      width.times { |x| ret += " #{ board[x][y] } " }
      ret += "|\n"
    end
    ret += "##{ num_line }#\n>\n\n"
  end

  # TODO: improve so the numbers match with the columns
  def num_line
    # TODO: this isn't perfect because numbers > 9 will take up more space
    ' ' + (1..width).to_a.join('  ') + ' '
  end

  def check_placement(col)
    # XXX MADE REDUNDANT BY MAIN GAME LOOP
    # first check that the column is in bounds
    unless col.between?(0, width - 1)
      puts 'Out of bounds!'
      return false
    end

    # then check if we can place any pieces in that column
    if top_of_col(col).full?
      puts 'This column is already full!'
      return false
    end
    true
  end

  # XXX might be good to move this into the Game class
  def check_win(row, col, some_player)
    return true if check_vertical(col, some_player)

    return true if check_horizontal(row, some_player)

    return true if check_sw_ne(row, col, some_player)

    return true if check_nw_se(row, col, some_player)
    # TODO: use the colored gem to highlight the winning move
    false
  end

  def check_vertical(col, p)
    count = r = 0
    while r < @height
      player_owns = place_at(col, r).belongs_to? p
      count = player_owns ? count + 1 : 0
      r += 1
      return true if count >= @game.connect_num
    end
    false
  end

  def check_horizontal(row, p)
    count = c = 0
    while c < @width
      player_owns = place_at(c, row).belongs_to? p
      count = player_owns ? count + 1 : 0
      c += 1
      return true if count >= @game.connect_num
    end
    false
  end

  def check_sw_ne(row, col, p)
    min = [row, col].min
    c = col - min
    r = row - min
    count = 0
    while in_bounds?(c, r)
      player_owns = place_at(c, r).belongs_to? p
      count = player_owns ? count + 1 : 0
      c += 1
      r += 1
      return true if count >= @game.connect_num
    end
    false
  end

  # let (c,r) be the place NW of (col,row) st (c,r) is at the NW-most corner
  # use y = mx + b, where
  # y = row, x = col, m = -1, and b is where the line intercepts the row-axis
  # thus, y = mx + b, y = -x + b, y = b - x, y + x = b, b = row + col
  # similarly, point (c, r) must also be on this line, so
  # r = mc + b, r = -c + b, r = b - c, r + c = b, b = c + r, c = b - r
  # we want to find b, so then we can find the correct NW corner
  # this NW point can either be located at (0, b) or (b - top, top)
  def check_nw_se(row, col, p)
    b = row + col

    # two options for possible intercepts
    y_int = { x: 0, y: b }
    x_int = { x: b - top_of_col, y: top_of_col }
    my_int = nil

    if in_bounds?(y_int[:x], y_int[:y])
      my_int = y_int
    elsif in_bounds?(x_int[:x], x_int[:y])
      my_int = x_int
    else
      return false
    end

    c = my_int[:x]
    r = my_int[:y]

    count = 0

    while in_bounds?(c, r)
      player_owns = at(c, r).belongs_to? p
      count = player_owns ? count + 1 : 0
      c += 1
      r -= 1
      return true if count >= @game.connect_num
    end
    false
  end
end # end class
