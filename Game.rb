class Game
  attr_reader :board
  attr_reader :players

  def initialize
    # TODO variable Board dimensions
    @board = Board.new
    @players = []
    @done = false

    puts 'Please enter the Players for this game, end with a "#"'

    while ((entry = gets.chomp)[0] != '#')
      @players << Player.new(@board, entry)
    end

    return false if @players.empty?

    commence_play
  end

  def commence_play
    #TODO
  end
end
