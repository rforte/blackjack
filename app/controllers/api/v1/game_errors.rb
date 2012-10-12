module Api::V1::GameErrors
  GAME_NOT_FOUND = {:status => 404, :msg => "This game does not exist", :code => 0x1000}
  GAME_ALREADY_COMPLETED = {:status => 403, :msg => "This game has already been completed.  Check the game status for results", :code => 0x1001}
  INVALID_ACTION = {:status => 403, :msg => "The only allowable cmds are 'hit' and 'stand'", :code => 0x1002}
  MUST_SUPPLY_ACTION = {:status => 403, :msg => "You must supply a player action", :code => 0x1003}
  UNHANDLED = {:status => 500, :msg => "Oops, we crapped the bed.", :code => 0x9999}
end