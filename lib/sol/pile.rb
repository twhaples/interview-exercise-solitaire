module Sol; end
class Sol::Pile
  attr_reader :cards
  def initialize
    @cards = []
  end

  def add(card)
    card.pile = self
    @cards << card
  end
end
