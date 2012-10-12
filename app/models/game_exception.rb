class GameException < StandardError
  attr_reader :err
  
  def initialize(err_hash)
    @err = err_hash
  end
end