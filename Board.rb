class Board
  attr_reader :width
  attr_reader :height
  attr_accessor :board
  attr_reader :game

  def initialize (g, w = 7, h = 6)
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

  def top_of_col(col_num)
    place_at(col_num, height - 1)
  end

  alias_method :place_at, :at

  def to_s
    ret = ">\n"
    ret += '#'
    ret += num_line
    #ret += ( ' * ' * @width )
    ret += "#\n"
    # TODO this doesn't look very reasonable ( USE AT METHOD )
    (0...width - 1).each do |i|
      ret += '|'
      (0..height).each do |j|
        ret += ( ' ' + @board[j][i].to_s + ' ' )
      end
      ret += "|\n"
      #ret += ( col_label + "\n" )
    end
    ret += '#'
    ret += num_line
    #ret += ( ' * ' * @width )
    ret += "#\n<\n\n"
    return ret
  end

  def [] (num)
    @board[num]
  end

  # TODO improve so the numbers match with the columns
  def num_line
    """
    ret = ''
    (1..height).each do |a|
      ret += ( a.even? ? ' X ' : ' O ' )
    end # each do
    ret
    """

    # this isn't perfect because numbers > 9 will take up more space XXX
    ' ' + (1..width).to_a.join('  ') + ' '
  end

  def check_placement (col)
    """
    # first check that the column is in bounds
    if !col.between?(0, width - 1)
      puts 'Out of bounds!' #TODO make error
      return false
    end
    """ # XXX MADE REDUNDANT BY MAIN GAME LOOP

    # then check if we can place any pieces in that column
    if top_of_col(col).full?
      puts 'This column is already full!' #TODO make error
      return false
    end

    true
  end

  # XXX might be good to move this into the Game class
  def check_win(row, col, some_player)
    # check vertical
    r = 0
    count = 0

    while (r < @height)
      player_owns = place_at(col, r).belongs_to?(some_player)
      count = player_owns ? count + 1 : 0
      r += 1
      return true if count >= @game.connect_num
    end

    # check horizontal
    c = 0
    count = 0
    while(c < @width)
      player_owns = place_at(c, row).belongs_to?(some_player)
      count = player_owns ? count + 1 : 0
      c += 1
      return true if count >= @game.connect_num
    end

    # check SW/NE
    min = [row, col].min
    c = col - min
    r = row - min
    count = 0

    while(in_bounds?(c, r))
      player_owns = at(c, r).belongs_to?(some_player)
      count = player_owns ? count + 1 : 0
      c += 1
      r += 1
      return true if count >= @game.connect_num
    end

    # check SE/NW
    # let (c,r) be the place NW of (col,row) st (c,r) is at the top of the grid
    # that means that c is (col + row) - height
    c = (col + row) - height # FIXME
    # and r is at the top
    r = height - 1

    puts "col #{c}"
    puts "row #{r}"

    while(in_bounds?(c, r))
      p place_at(c, r)
      player_owns = at(c, r).belongs_to?(some_player)
      count = player_owns ? count + 1 : 0
      c += 1
      r -= 1
      return true if count >= @game.connect_num
    end
    # TODO: use the colored gem to highlight the winning move
    false
  end
end # end class
