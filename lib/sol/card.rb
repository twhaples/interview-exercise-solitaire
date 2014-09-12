module Sol; end
class Sol::Card
  attr_reader :rank
  attr_reader :suit
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end
