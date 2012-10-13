require 'spec_helper'

describe Api::V1::GameController do
  before(:each) do
    @game = Game.create!
    @completed = Game.create!
    @completed.playing = false
    @completed.save!    
  end
  
  it "should start a new game" do
    get :create, :format => :json
    response.response_code.should eq(200)
  end
  
  it "should show status of a game" do
    get :show, :id => @game.id, :format => :json
    response.response_code.should eq(200)
  end
  
  # it "should tell user game is over if they try to hit or stand when the game is over" do
  #   post :update, {:id => @completed.id, :cmd => 'hit'}
  #   response.response_code.should eq(Api::V1::GameErrors::GAME_ALREADY_COMPLETED[:status])
  #   json = JSON::parse(response.body)
  #   json['code'].should eq(Api::V1::GameErrors::GAME_ALREADY_COMPLETED[:code])
  # end

  it "if game is complete then just return the status of the game" do
    golden = JSON::parse GamePresenter.new(@completed).to_json
    post :update, {:id => @completed.id, :cmd => 'hit'}
    response.response_code.should eq(200)
    json = JSON::parse(response.body)
    json.should eq(golden)
  end
  
  it "should report game not found on invalid gid" do
    post :show, :id => '1234'
    response.response_code.should eq(404)
    json = JSON::parse(response.body)
    json['code'].should eq(Api::V1::GameErrors::GAME_NOT_FOUND[:code])
  end
  
  it "should return an error if invalid cmd" do
    post :update, {:id => @game, :cmd => 'xxx'}
    response.response_code.should eq(403)
    json = JSON::parse(response.body)
    json['code'].should eq(Api::V1::GameErrors::INVALID_ACTION[:code])
  end

  it "should return an error if no cmd" do
    post :update, {:id => @game}
    response.response_code.should eq(403)
    json = JSON::parse(response.body)
    json['code'].should eq(Api::V1::GameErrors::MUST_SUPPLY_ACTION[:code])
  end

end
