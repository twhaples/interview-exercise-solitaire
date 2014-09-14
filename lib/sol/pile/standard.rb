require 'sol/pile'

class Sol::Pile::Standard < Sol::Pile
  # all faceup piles have a facedown pile underneath them
  attribute :facedown, Object 

  def can_putdown?(card); true; end
  def visible?; true; end
  def pickup(card)
    raise ArgumentError unless index = cards.index(card)
    picked_up = cards.pop(cards.length - index).flatten
    picked_up.each {|c| c.pile = nil }
    return picked_up
  end
  def autoflip!
    if cards.empty?
      card = facedown.flip
      add(card) if card
    end
  end
end
