module Sol; end
class Sol::Card
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
end
