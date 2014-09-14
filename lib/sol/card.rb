module Sol; end
class Sol::Card
  Colors = {
    :clubs => :black,
    :spades => :black,
    :diamonds => :red,
    :hearts => :red,
  }
  attr_reader :rank
  attr_reader :suit
  attr_reader :pile
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
 
  def pile=(pile)
    raise ArgumentError if @pile.nil? == pile.nil?
    @pile = pile
  end

  def to_s
    "#{@rank} of #{@suit}"
  end

  def color
    Colors[@suit]
  end
end
