require 'virtus'
module Sol; end

class Sol::Pile
  include Virtus.model

  attr_reader :cards
  def initialize(*args)
    super(*args)
    @cards = []
  end

  def size; @cards.length; end

  def add(card)
    card.pile = self
    @cards << card
  end
  def putdown(new_cards)
    new_cards.each {|c| add(c) }
  end
  def can_pickup?(card)
    return false
  end 
end
