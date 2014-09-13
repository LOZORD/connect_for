class AIPlayer < Player
  def decide_move
    col = defend
    return col unless col.nil?
    col = attack
    return col unless col.nil?
    col = rand(1...board.width)
    return col
  end

  def defend

  end

  def attack
  
  end
end
