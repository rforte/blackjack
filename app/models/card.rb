#
#  Helper class
#
class Card
  @@RANK = %W(A 2 3 4 5 6 7 8 9 10 J Q K)
  @@SUIT = %W(c d h s)
  @@VALS = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
  
  def self.to_s(card)
    @@RANK[card % @@RANK.length] + @@SUIT[card % @@SUIT.length]
  end
  
  def self.to_i(card)
    @@VALS[card % @@VALS.length]
  end
  
  def self.is_ace?(card)
    (card % @@RANK.length) == 0
  end  
end
