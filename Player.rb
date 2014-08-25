MAX_NUM_PLAYERS = 4

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
