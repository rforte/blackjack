#
#  DealerEngine would normally be a base class with the interfaces of:
#  play(game)
#  For simplicity, I'm not implementing the base + sub classes
#
class DealerFactory
  DEALER_STANDS_ON_SOFT_17 = 1
  
  def self.create(dealer_type)
    case dealer_type
    when DEALER_STANDS_ON_SOFT_17
      return DealerEngine.new
    end
  end
end