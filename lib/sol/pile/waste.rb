require 'sol/pile'
class Sol::Pile::Waste < Sol::Pile
  def visible?; true; end

  def recycle
    old_cards = @cards
    old_cards.each {|c| c.pile = nil }
    @cards = []
    return old_cards
  end

  def pickup(card)
    raise ArgumentError unless card == @cards.last
    return [@cards.pop.tap {|c| c.pile = nil }]
  end
end
