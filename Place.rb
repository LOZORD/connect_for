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

  alias_method :belongs_to?, :belongs_to_player?

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

  def belongs_to?(p)
    belongs_to_player?(p)
  end

  def to_s
    case @place_type
    when RED
      return 'R'.red
    when BLUE
      return 'B'.blue
    when GREEN
      return 'G'.green
    when YELLOW
      return 'Y'.yellow
    else
      return '_'.white
    end
  end
end
