class Hand
  def self.compute(hand)
    total = 0
    ace_count = 0
    
    hand.each do |card|
      total += Card.to_i(card)
      ace_count += Card.is_ace?(card) ? 1 : 0      
    end
    
    while ace_count > 0 && total > 21
      total -= 10
      ace_count -= 1
    end
    
    total
  end
end