require 'sol/pile'
class Sol::Pile::Stack < Sol::Pile
  def visible?; false; end
  def shuffle!; @cards.shuffle!; end

  def deal
    raise ArgumentError if @cards.empty?
    card = @cards.shift
    card.pile = nil
    return card
  end

  def refresh(cards)
    cards.each {|c| add(c) }
  end
end
