class RuleEngine
  def solve(game)
    solve_hands(game.player_hand, game.dealer_hand, game.playing)
  end
  
  def solve_hands(player_hand, dealer_hand, playing)
    ph = Hand.compute( player_hand )
    dh = Hand.compute( dealer_hand )

    #
    #  Initial deal state
    #
    if( player_hand.length == 2 && dealer_hand.length == 2 && playing)
      return {:winner => :draw, :reason => :both_players_have_blackjack } if ph == 21 && dh == 21
      return {:winner => :player, :reason => :blackjack } if ph == 21
      return {:winner => :dealer, :reason => :blackjack } if dh == 21
    #
    #  While the player is still acting
    #
    elsif playing
      return {:winner => :dealer, :reason => :player_busted } if ph > 21
    #
    #  Player is done now dealer's turn
    #
    else
      return {:winner => :player, :reason => :dealer_busted } if dh > 21 
      return {:winner => :player, :reason => :player_beat_dealer } if ph > dh
      return {:winner => :dealer, :reason => :dealer_beat_player } if dh > ph
      return {:winner => :draw, :reason => :push } if dh == ph
    end
    
    return {:winner => :none, :reason => :still_playing }
  end
  
  #
  #  The rules only allow hit and stand for this version
  #
  def perform(cmd, game)
    puts "*** PERFORM ***"
    case cmd
    when :hit
      game.deal_card_to_player
    when :stand
      game.playing = false # conclude player's turn
      dealer = DealerFactory.create( game.dealer_type )
      dealer.play( game )
    end
    
    outcome = solve(game)
    game.playing = false unless outcome[:winner] == :none
    puts "*** LEAVING PERFORM ***"
    
    outcome
  end
  
  def validate_cmd(cmd)
    raise GameException.new(MUST_SUPPLY_ACTION) if cmd.blank?
    cmd = cmd.downcase.to_sym
    raise GameException.new(INVALID_ACTION) unless [:hit, :stand].include?(cmd)
    cmd
  end
  
end
