class Game
  attr_reader :board
  attr_reader :players

  def initialize
    # TODO variable Board dimensions
    @board = Board.new
    @players = []
    @done = false
    @curr_turn = 0

    puts 'Please enter the Players for this game, end with a "#"'

    while ((entry = gets.chomp)[0] != '#')
      @players << Player.new(@board, entry)
      puts "\tWelcome to the game #{entry}!"
    end

    return false if @players.empty?
  end

  def play

    curr_player = nil

    while(!@done)
      puts @board.to_s
      curr_player = get_curr_player

      print "#{curr_player.to_s}'s turn! "
      print  "Enter a number between 1 and #{@board.width}: "

      while (!(col = gets.chomp.to_i).between?(1, @board.width))
        puts  "Please enter a number between 1 and #{@board.width}!"
      end

      curr_player.place_piece(col)

      #TODO check that if that was a winning move
      @done = @board.check_win(col, curr_player.color)

      @curr_turn += 1
    end

    puts "#{curr_player.to_s} is the winner!"
  end

  def get_curr_player
    index = @curr_turn % @players.size

    @players[index]
  end
end
