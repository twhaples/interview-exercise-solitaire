module Sol; end
class Sol::Pile
  attr_reader :cards
  def initialize
    @cards = []
  end

  def size; @cards.length; end

  def add(card)
    card.pile = self
    @cards << card
  end

  def remove
    raise ArgumentError if @cards.empty?
    card = @cards.shift
    card.pile = nil
    return card
  end
end
