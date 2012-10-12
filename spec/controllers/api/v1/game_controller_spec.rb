require 'spec_helper'

describe Api::V1::GameController do
  before(:each) do
    @game = Game.create!
    @completed = Game.create!
    @completed.playing = false
    @completed.save!    
  end
  
  it "should start a new game" do
    get :update
    response.code.should eq(200)
  end
  
  it "should show status of a game" do
    get :show, {:id => @game.id}
    response.code.should eq(200)
  end
  
  it "should tell user game is over if they try to hit or stand when the game is over" do
    post :update, {:id => @completed.id, :cmd => 'hit'}
    response.response_code.should eq(Api::V1::GameErrors::GAME_ALREADY_COMPLETED[:status])
    json = JSON::parse(response.body)
    json['code'].should eq(Api::V1::GameErrors::GAME_ALREADY_COMPLETED[:code])
  end  
end
