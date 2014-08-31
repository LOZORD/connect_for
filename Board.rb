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

  def check_win(row, col, some_player)
    # check vertical
    r = 0
    count = 0

    puts 'MOVE WAS'
    p at(col, row)
    puts '***'

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
    # check SW/NE TODO
    min = [row, col].min
    col_min = col - min
    row_min = row - min

    puts "col_min = #{col_min}"
    puts "row_min = #{row_min}"

    count = 0
    while(in_bounds?(col_min, row_min))
      p at(col_min, row_min)
      player_owns = at(col_min, row_min).belongs_to?(some_player)
      count = player_owns ? count + 1 :0
      col_min += 1
      row_min += 1
      return true if count >= @game.connect_num
    end
    # check SE/NW TODO

    false
  end
end # end class
