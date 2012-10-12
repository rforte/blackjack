require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
  let(:game_opt) { {:num_decks => 1, :rules => RuleFactory::HIT_AND_STAND_ONLY, :dealer_type => DealerFactory::DEALER_STANDS_ON_SOFT_17} }
  @re = RuleEngine.new
  
  it "should end right away if player bj" do
    g = Game.create! :num_decks => 1, :deck => [2,2,2,2,2,0,2,10]
    res = g.outcome
    res[:winner].should eq(:player)
    res[:reason].should eq(:blackjack)
    g.playing.should eq(false)
    g.delete
  end

  it "should end right away if dealer bj" do
    g = Game.create! :num_decks => 1, :deck => [2,2,2,2,10,2,0,2]
    res = g.outcome
    res[:winner].should eq(:dealer)
    res[:reason].should eq(:blackjack)
    g.playing.should eq(false)
    g.delete
  end

  it "should end right away if dealer bj and player bj" do
    g = Game.create! :num_decks => 1, :deck => [2,2,2,2,10,10,0,0]
    res = g.outcome
    res[:winner].should eq(:draw)
    res[:reason].should eq(:both_players_have_blackjack)
    g.playing.should eq(false)
    g.delete
  end
  
  it "player should win by beating dealer" do    
    g = Game.new( game_opt.merge({ :player_hand => [10,10], :dealer_hand => [10, 8] }) )
    g.bootstrap
    g.play 'stand'
    g.outcome[:winner].should eq(:player)
    g.outcome[:reason].should eq(:player_beat_dealer)
  end

  it "player should lose by busting" do    
    g = Game.new( game_opt.merge({ :player_hand => [10,6], :dealer_hand => [10, 8], :deck => [9,9,9,9] }) )
    g.bootstrap
    g.play 'hit'
    g.outcome[:winner].should eq(:dealer)
    g.outcome[:reason].should eq(:player_busted)
  end
  
  it "player should lose by getting beat by dealer" do
    g = Game.new( game_opt.merge({ :player_hand => [6,6], :dealer_hand => [10, 10], :deck => [2,2,2,2] }) )
    g.bootstrap
    g.play 'hit'
    g.play 'stand'
    g.outcome[:winner].should eq(:dealer)
    g.outcome[:reason].should eq(:dealer_beat_player)    
  end

  # it "player should win by getting beat by dealer" do
  #   g = Game.new( game_opt.merge({ :player_hand => [10,2], :dealer_hand => [10, 10], :deck => [9,9,9,9] }) )
  #   g.bootstrap
  #   g.play 'hit'
  #   g.outcome[:winner].should eq(:dealer)
  #   g.outcome[:reason].should eq(:dealer_beat_player)    
  # end
end
