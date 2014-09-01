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

  def top_of_col(col_num)
    place_at(col_num, height - 1)
  end

  alias_method :place_at, :at

  def to_s
    ret = ">\n"
    ret += '#'
    ret += num_line
    # ret += ( ' * ' * @width )
    ret += "#\n"
    # TODO: this doesn't look very reasonable ( USE AT METHOD )
    (0...width - 1).each do |i|
      ret += '|'
      (0..height).each do |j|
        ret += (' ' + @board[j][i].to_s + ' ')
      end
      ret += "|\n"
      # ret += ( col_label + "\n" )
    end
    ret += '#'
    ret += num_line
    # ret += ( ' * ' * @width )
    ret += "#\n<\n\n"
  end

  # TODO: improve so the numbers match with the columns
  def num_line
    # this isn't perfect because numbers > 9 will take up more space XXX
    ' ' + (1..width).to_a.join('  ') + ' '
  end

  def check_placement(col)
    """
    # first check that the column is in bounds
    if !col.between?(0, width - 1)
      puts 'Out of bounds!' #TODO make error
      return false
    end
    """ # XXX MADE REDUNDANT BY MAIN GAME LOOP
    # then check if we can place any pieces in that column
    if top_of_col(col).full?
      puts 'This column is already full!' # TODO: make error
      return false
    end
    true
  end

  # XXX might be good to move this into the Game class
  def check_win(row, col, some_player)
    return true if check_vertical(col, some_player)

    return true if check_horizontal(row, some_player)

    return true if check_sw_ne(row, col, some_player)

    return true if check_nw_se(row, col, some_player) # FIXME
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

  # let (c,r) be the place NW of (col,row) st (c,r) is at the top of the grid
  # that means that c is (col + row) - height
  # and r is at the top
  def check_nw_se(row, col, p)
    c = (col + row) - height # FIXME
    r = height - 1
    puts "col #{c}" # XXX
    puts "row #{r}" # XXX
    while in_bounds?(c, r)
      p place_at(c, r)
      player_owns = at(c, r).belongs_to? p
      count = player_owns ? count + 1 : 0
      c += 1
      r -= 1
      return true if count >= @game.connect_num
    end
    false
  end
end # end class
