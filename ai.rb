# This class implements the AI logic for a pseudo-player bot
class AIPlayer < Player
  def decide_move
    col = defend
    return col unless col.nil?
    col = attack
    return col unless col.nil?
    # otherwise, just return a random column
    rand(0...board.width)
  end

  def defend
    # move across the board, looking for possible wins for other players
    # TODO
    nil
  end

  def attack
    # TODO
    nil
  end
end
