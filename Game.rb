class Game
  attr_reader :board
  attr_reader :players
  attr_reader :connect_num

  # TODO args for Board dimensions
  def initialize
    @board = Board.new(self)
    @players = []
    @done = false
    @curr_turn = 0
    @connect_num = 4 # XXX hardcoded

    puts 'Please enter the Players for this game, end with a "#"'

    while ((entry = gets.chomp.strip)[0] != '#')
      # TODO put in check for duplicate names
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

      while (!(col = gets.chomp.strip.to_i).between?(1, @board.width))
        print  "Please enter a number between 1 and #{@board.width}! "
      end

      # human indexing to computer indexing
      col = col - 1

      while (!@board.check_placement(col))
        print "\tPlease enter a new number between 1 and #{@board.width}! "
        col = gets.chomp.strip.to_i - 1
      end

      row = curr_player.place_piece(col)

      #TODO check that if that was a winning move
      @done = @board.check_win(row, col, curr_player)

      @curr_turn += 1
    end
    puts @board.to_s
    puts "#{curr_player.to_s} is the winner!".cyan
  end

  def get_curr_player
    index = @curr_turn % @players.size

    @players[index]
  end
end
