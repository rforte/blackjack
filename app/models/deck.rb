class Deck
  attr_reader :seed
  
  def initialize(num_decks = 1, with_array = nil, perform_shuffle = true, seed = nil)
    @cards = with_array || Array(0..(52 *num_decks -1 ))
    shuffle_deck(seed) if perform_shuffle
  end
  
  def deal_card
    @cards.pop
  end
  
  def to_a
    @cards
  end  

  private
  
  def shuffle_deck(with_seed)
    @seed = with_seed || Time.now.to_i  # For simplicity, using epoch time as a seed
    rng = Random.new( seed )
    @cards.shuffle!( random:rng )
  end
end