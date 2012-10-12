class GamePresenter
  attr_reader :data
  
  def initialize(game, debug = false)
    @data = game
    @debug = debug
  end
  
  def as_json( include_root = false )
    ph = @data.player_hand.map { |card| Card.to_s(card) }
    if @data.dealer_hand.length == 2 && @data.playing
      dh = [Card.to_s(@data.dealer_hand[0]), "*"]
    else
      dh = @data.dealer_hand.map { |card| Card.to_s(card) }
    end
    
    h = {
      :gid => @data.id,
      :dealer => dh,
      :player => ph
    }.merge!(@data.outcome)
    
#    h[:reason].to_s.humanize
    h.merge!({ :seed => @data.seed }) if @debug
    
    h
  end
end