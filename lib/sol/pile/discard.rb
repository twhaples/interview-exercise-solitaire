require 'sol/pile'
class Sol::Pile::Discard < Sol::Pile
  def visible?; true; end
  def putdown(cards)
    cards.each {|c| add(c) }
  end
end
