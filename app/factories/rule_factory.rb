#
#  RuleEngine would normally be a base class with the interfaces of:
#  solve(game)
#  perform(action, game)
#  For simplicity, I'm not implementing the base + sub classes
#
class RuleFactory
  HIT_AND_STAND_ONLY = 1
  
  def self.create(rule_type)
    case rule_type
    when HIT_AND_STAND_ONLY
      return RuleEngine.new
    else
      raise "Unsupported game type #{rule_type}"
    end
  end
end