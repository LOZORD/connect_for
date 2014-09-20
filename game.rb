# This class implements a single game of Connect Four
class Game
  attr_reader :board
  attr_reader :players
  attr_reader :connect_num

  def initialize(w = 7, h = 6, cn = 4, some_players = [])
    @board = Board.new(self, w, h)
    @done = false
    @curr_turn = 0
    @connect_num = cn
    if some_players.empty?
      puts 'Enter the player names for this game, each on a line, end with "#"'
      build_players
    else
      @players = some_players
    end
  end

  def build_players
    loop do
      entry = gets.chomp.strip
      if entry == '#'
        break
      elsif valid_name? entry
        add_player entry
      end
    end
    @players.empty?
  end

  def valid_name?(some_name)
    if some_name.empty?
      puts 'Please enter a non-empty name!'.red
    elsif (/^[\w]+$/ =~ some_name).nil?
      puts 'Please enter a valid ASCII alphabet-only name'.red
    elsif player_name? some_name
      puts 'That name is already taken. Please enter a new name!'.red
    end
    true
  end

  def add_player(some_name)
    if some_name.downcase.start_with?('bot')
      @players << AIPlayer.new(@board, entry)
    else
      @players << Player.new(@board, entry)
    end
    puts "\tWelcome to the game #{ entry }!".yellow
  end

  def player_name?(name)
    !(@players.index { |player| player.name == name }).nil?
  end

  def play
    until @done
      puts board

      print "#{curr_player}'s turn! "
      print "Enter a number between 1 and #{@board.width}: "

      if curr_player.is_a_bot?
        col = curr_player.decide_move
        puts col
      else
        until (col = gets.chomp.strip.to_i).between?(1, @board.width)
          print "Please enter a number between 1 and #{@board.width}! "
        end

        # human indexing to computer indexing
        col -= 1
        until @board.check_placement(col)
          print "\tPlease enter a new number between 1 and #{@board.width}! "
          col = gets.chomp.strip.to_i - 1
        end
      end

      row = curr_player.place_piece(col)

      seq = @board.check_win(row, col, curr_player)

      @done = (seq.size == @connect_num)

      if @done
        puts @board.to_s(seq)
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
