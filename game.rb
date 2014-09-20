# This class implements a single game of Connect Four
class Game
  attr_reader :board
  attr_reader :players
  attr_reader :connect_num

  def initialize(options = {})
    w = options[:width] || 6
    h = options[:height] || 7
    cn = options[:connect_number] || 4
    some_players = options[:players] || []
    @board = Board.new(self, w, h)
    @done = false
    @curr_turn = 0
    @connect_num = cn
    if some_players.empty?
      puts 'Enter the player names for this game, each on a line, end with "#"'
      puts 'To end game in a draw, enter "DRAW" for your turn'
      build_players
    else
      some_players.each { |name| add_player name if valid_name? name }
    end
  end

  def build_players
    @players ||= []
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
    @players ||= []
    if some_name.empty?
      puts 'Please enter a non-empty name!'.red
    elsif (/^[\w]+$/ =~ some_name).nil?
      puts 'Please enter a valid ASCII alphabet-only name'.red
    elsif player_name? some_name
      puts 'That name is already taken. Please enter a new name!'.red
    else
      true
    end
  end

  def add_player(some_name)
    @players ||= []
    if some_name.downcase.start_with?('bot')
      @players << AIPlayer.new(@board, some_name)
    else
      @players << Player.new(@board, some_name)
    end
    puts "\tWelcome to the game #{ some_name }!".yellow
  end

  def player_name?(name)
    !(@players.index { |player| player.name == name }).nil?
  end

  def play
    until @done
      start_round
      if curr_player.is_a_bot?
        col = curr_player.decide_move
        until board.check_placement(col)
          col = curr_player.decide_move
        end
        puts col + 1
      else
        col = gets.chomp.strip
        check_draw if col.upcase == 'DRAW'
        col = col.to_i
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

      # TODO: create counter that checks if game is over ie there are no possible moves
      # TODO: also create special char that players enter to initiate a tie/draw

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

  def start_round
    puts board
    print "#{curr_player}'s turn! "
    print "Enter a number between 1 and #{board.width}: "
  end

  def curr_player
    index = @curr_turn % @players.size
    @players[index]
  end

  def check_draw
    # TODO: implement
  end
end
