require 'sol/pile'
class Sol::Pile::Waste < Sol::Pile
  def visible?; true; end

  def recycle
    old_cards = @cards
    old_cards.each {|c| c.pile = nil }
    @cards = []
    return old_cards
  end

  def can_pickup?(card)
    return card == @cards.last
  end
  def pickup(card)
    raise ArgumentError unless can_pickup?(card)
    return [@cards.pop.tap {|c| c.pile = nil }]
  end

  def autoflip!
  end
end
