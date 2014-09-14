require 'sol/pile'
class Sol::Pile::Standard < Sol::Pile
  def visible?; true; end
  def pickup(card)
    raise ArgumentError unless index = cards.index(card)
    picked_up = cards.pop(cards.length - index).flatten
    picked_up.each {|c| c.pile = nil }
    return picked_up
  end
  def putdown(cards)
    cards.each {|c| add(c) }
  end
end
