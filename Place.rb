# This class is what makes up the elements of the Board grid
# Places are (x,y) coordinates that are owned by no one, or by a single player
class Place
  EMPTY = :empty
  RED = :red
  BLUE = :blue
  GREEN = :green
  YELLOW = :yellow

  attr_accessor :place_type
  attr_reader :x
  attr_reader :y

  def initialize(some_x, some_y, type = EMPTY)
    @x = some_x
    @y = some_y
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

  alias_method :belongs_to?, :belongs_to_player?

  def same_xy? (other_place)
    self.x == other_place.x && self.y == other_place.y
  end

  def to_s(win_print = false)
    case @place_type
    when RED
      return (win_print ? 'R'.red.reversed : 'R'.red)
    when BLUE
      return (win_print ? 'B'.blue.reversed : 'B'.blue)
    when GREEN
      return (win_print ? 'G'.green.reversed : 'G'.green)
    when YELLOW
      return (win_print ? 'Y'.yellow.reversed : 'Y'.yellow)
    else
      return '_'.white
    end
  end
end
