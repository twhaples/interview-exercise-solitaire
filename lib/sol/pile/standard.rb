require 'sol/pile'

class Sol::Pile::Standard < Sol::Pile
  # all faceup piles have a facedown pile underneath them
  attribute :facedown, Object 
  def visible?; true; end

  def can_putdown?(new_cards)
    last_color = :wild
    [*cards, *new_cards].map(&:color).each do |color|
      return false unless last_color != color
      last_color = color
    end

    order = cards.empty? ? [14]: []
    order.concat(cards.map(&:rank))
    order.concat(new_cards.map(&:rank))
    return false unless order == order.sort.reverse

    return false unless order == ((order.last)..(order.first)).to_a.reverse
    return true
  end
  def pickup(card)
    raise ArgumentError unless index = cards.index(card)
    picked_up = cards.pop(cards.length - index)
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
