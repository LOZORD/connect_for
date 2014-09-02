# This class implements a single game of Connect Four
class Game
  attr_reader :board
  attr_reader :players
  attr_reader :connect_num

  def initialize(w = 7, h = 6, cn = 4)
    @board = Board.new(self, w, h)
    @players = []
    @done = false
    @curr_turn = 0
    @connect_num = cn

    return false if build_players.empty? # TODO: raise exception or something
  end

  def build_players
    puts 'Please enter the Players for this game, end with a "#"'
    loop do
      entry = gets.chomp.strip
      if entry.empty?
        puts 'Please enter a non-empty name!'
      elsif entry == '#'
        break
      elsif (/^[a-zA-Z]+$/ =~ entry).nil?
        puts 'Please enter a valid ASCII alphabet-only name'
      elsif player_name? entry
        puts 'That name is already taken. Please enter a new name!'
      else
        @players << Player.new(@board, entry)
        puts "\tWelcome to the game #{ entry }!"
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

      if @done
        puts @board
        # TODO: highligh the winning move
        puts "#{curr_player} is the winner!".cyan
        break
      end

      @curr_turn += 1
    end
  end

  def curr_player
    index = @curr_turn % @players.size
    @players[index]
  end
end
