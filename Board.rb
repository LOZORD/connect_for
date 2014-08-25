class Board
  attr_reader :width
  attr_reader :height
  attr_accessor :board

  def initialize (w = 7, h = 6)
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

      """
      col_label = (i + 1).to_s

      while (col_label.size < width.to_s.size)
        col_label += ' '
      end
      """

      #ret += ( col_label )

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
end

