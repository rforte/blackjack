class Api::V1::GameController < ApplicationController  
  include Api::V1::GameErrors
  respond_to :json
  around_filter :catch_exceptions
  
  def create
    g = Game.create! :num_decks => 6, :rules => RuleFactory::HIT_AND_STAND_ONLY, :dealer_type => DealerFactory::DEALER_STANDS_ON_SOFT_17
    respond_with GamePresenter.new(g)
  end

  def show
    g = Game.retrieve( params[:id] )
    respond_with GamePresenter.new(g)
  end
  
  def update
    g = Game.retrieve( params[:id] )
    #error(GAME_ALREADY_COMPLETED) and return unless g.playing # instead of returning an error return game state
    g.play!( params[:cmd] ) if g.playing
    render :json => GamePresenter.new(g).to_json
  end
  
  private
  
  def catch_exceptions
    yield
  rescue GameException => e
    error(e.err)
  rescue
    error(UNHANDLED)
  end
end
