class DealerEngine  
  #
  #  Strategy is to stand on soft-17
  #
  def play( game )
    while( Hand.compute( game.dealer_hand ) < 17 )
      game.deal_card_to_dealer
    end
  end
end