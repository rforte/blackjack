class Game
  include MongoMapper::Document
  include Api::V1::GameErrors
  
  before_save :update_state
  before_create :bootstrap
  
  #  XXX - Probably good to have a transaction id/log as well for db consistency and audit'ing but not for this version
  key :deck, Array                                      # i don't really need to store the entire deck. 
                                                        # really only need the first N (todo: next version).
  key :player_hand, Array, :alias => :ph
  key :dealer_hand, Array, :alias => :dh
  key :playing, Boolean, :alias => :p                   # false if game over -- could implicitly determine
  key :num_decks, Integer, :alias => :n
  key :rules, Integer, :alias => :r                     # surrender avail, double down etc...
  key :dealer_type, Integer, :alias => :dt              # dealer behavior -- stand on soft-17 etc...
  key :seed, Integer, :alias => :s                      # in case we want to reproduce a hand history assuming identical rng implementations
  key :outcome, Hash, :alias => :o                      # cache game state
  
  #  Dealer BJ seed 1349999491
  
  #
  #  Pull data out of the DB and bootstrap the game
  #
  def self.retrieve(game_id)
    g = Game.find( game_id )
    raise GameException.new(GAME_NOT_FOUND) if g.nil?
    g.bootstrap
  end
  
  #
  #  Helper methods
  #
  def deal_card_to_player
    player_hand << @shoe.deal_card
  end
  
  def deal_card_to_dealer
    dealer_hand << @shoe.deal_card
  end
  
  #
  #  Allow playing the game without saving the state -- mostly for debugging
  #
  def play(cmd)
    play_game(cmd)
  end
  
  def play!(cmd)
    play_game(cmd)
    self.save!
  end

  #
  #  Called when we need to restore a game from the DB or start a new one
  #
  def bootstrap
    generate_deck = self.deck.empty?
    @shoe = Deck.new(self.num_decks || 1, generate_deck ? nil : self.deck, generate_deck, self.seed )
    @rule_engine = RuleFactory.create( self.rules || RuleFactory::HIT_AND_STAND_ONLY )
    if new_record?
      self.playing = true
      start_game if player_hand.empty? && dealer_hand.empty? # really only need to check this when i want to setup hands in the debugger for testing
      self.outcome = @rule_engine.solve(self)
      self.playing = self.outcome[:winner] == :none
      self.deck = @shoe.to_a
    end
    
    self
  end
  
  private
  
  def play_game(cmd)
    cmd = @rule_engine.validate_cmd(cmd)
    self.outcome = @rule_engine.perform(cmd, self)
  end
  
  def start_game
    #
    #  Deal initial hands
    #
    2.times do
      deal_card_to_player
      deal_card_to_dealer
    end
  end

  #
  #  For serializing back to the db
  #
  def update_state
    self.deck = @shoe.to_a if @shoe
  end
end
