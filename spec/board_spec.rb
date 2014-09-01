require 'connect_four'

describe Board do

  describe 'in_bounds?' do
    @board = Board.new

    @board.in_bounds?(5, 8).should == false
  end
end
