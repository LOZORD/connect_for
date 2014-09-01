# This class implements a single game of Connect Four
class Game
  attr_reader :board
  attr_reader :players
  attr_reader :connect_num

  def initialize(w = 7, h = 6)
    @board = Board.new(self, w, h)
    @players = []
    @done = false
    @curr_turn = 0
    @connect_num = 4 # XXX hardcoded

    return false if build_players.empty? # TODO: raise exception or something
  end

  def build_players
    puts 'Please enter the Players for this game, end with a "#"'
    while ((entry = gets.chomp.strip)[0] != '#')
      if player_name? entry
        puts 'That name is already taken. Please enter a new name!'
      else
        @players << Player.new(@board, entry)
        puts "\tWelcome to the game #{entry}!"
      end
    end
    @players
  end

  def player_name?(name)
    !(@players.index { |player| player.name == name }).nil?
  end

  def play
    until @done
      puts board

      print "#{curr_player}'s turn! "
      print "Enter a number between 1 and #{@board.width}: "

      until (col = gets.chomp.strip.to_i).between?(1, @board.width)
        print "Please enter a number between 1 and #{@board.width}! "
      end

      # human indexing to computer indexing
      col -= 1

      until @board.check_placement(col)
        print "\tPlease enter a new number between 1 and #{@board.width}! "
        col = gets.chomp.strip.to_i - 1
      end

      row = curr_player.place_piece(col)

      # TODO: check that if that was a winning move
      @done = @board.check_win(row, col, curr_player)

      @curr_turn += 1
    end
    puts @board.to_s
    puts "#{curr_player} is the winner!".cyan
  end

  def curr_player
    index = @curr_turn % @players.size
    @players[index]
  end
end
