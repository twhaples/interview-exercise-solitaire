require 'sol/pile'
class Sol::Pile::Discard < Sol::Pile
  def visible?; true; end
  def putdown(new_cards)
    new_cards.each {|c| add(c) }
  end
  def can_putdown?(new_cards)
    future_cards = [*cards, *new_cards]
    return false unless future_cards.map(&:suit).uniq.length == 1
    return false unless future_cards.map(&:rank) == (1..future_cards.length).to_a
    return true
  end
end
