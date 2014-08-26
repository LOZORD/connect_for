class Board
  attr_reader :width
  attr_reader :height
  attr_accessor :board
  attr_reader :game

  def initialize (g, w = 7, h = 6)
    @game = g
    @width = w
    @height = h
    @board = Array.new(w) { Array.new (h) { Place.new } }
  end

  def in_bounds?(x, y)
    x.between?(0, width) && y.between?(0, height)
  end

  def to_s
    ret = ">\n"
    ret += '#'
    ret += num_line
    #ret += ( ' * ' * @width )
    ret += "#\n"
    # TODO this doesn't look very reasonable
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

  def check_win(row, col, some_player)
    # check vertical
    r = 0
    count = 0

    while (r < @height)
      player_owns = @board[col][r].belongs_to?(some_player)
      count = player_owns ? count + 1 : 0
      r += 1
      return true if count >= @game.connect_num
    end

    # check horizontal
    c = 0
    count = 0

    while(c < @width)
      player_owns = @board[c][row].belongs_to?(some_player)
      count = player_owns ? count + 1 : 0
      c += 1
      return true if count >= @game.connect_num
    end
    # check SE/NW TODO

    # check SW/NE TODO

    false
  end
  """
  # the block will determine which direction things go in
  def check_iterate (init_row = 0, init_col = 0, some_player ,&block)
    row = init_row
    col = init_col

    count = 0

    while (row < @height)
      while (col < @width)
        player_owns? = board[row][col].belongs_to?(some_player)

        count = player_owns? ? count + 1 : 0

        return true if count >= @game.connect_num

        yield block
      end
    end

    false
  end
  """
end # end class
