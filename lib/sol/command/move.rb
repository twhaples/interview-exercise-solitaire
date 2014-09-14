require 'sol/command'

class Sol::Command::Move < Sol::Command
  attribute :card, String
  attribute :dest, String

  def invalid_move
    return feedback(:message => 'Invalid move', :render => false)
  end
  def execute(session)
    card = find_card(session)
    start_pile = card.pile
    return invalid_move unless start_pile.can_pickup?(card)
    destination = find_dest(session)
    
    cards = start_pile.pickup(card)
    if (destination.can_putdown?(cards))
      destination.putdown(cards)
      start_pile.autoflip!
      return feedback
    else
      # put them back
      start_pile.putdown(cards)
      return invalid_move
    end
 end

  def to_s; "move card #{card} to pile #{dest}"; end
  def ==(card)
    card.to_s == self.to_s
  end

  def find_dest(session)
    if self.dest =~ /\A[1-7]\Z/
      return session.get_pile(:faceup, dest.to_i - 1)
    elsif (discard = {'d' => 0, 'h' => 1, 'c' => 2, 's' => 3}[self.dest])
      return session.get_pile(:discard, discard)
    end
    raise ArgumentError
  end

  def find_card(session)
    raise ArgumentError unless self.card =~ /[cdsh][A2-9TJKQ]/i
    suit, rank = self.card.split(//) 
    index = 13*['c','d', 's', 'h'].index(suit.downcase) + ({'a' => 1, 't' => 10, 'j' => 11, 'q' => 12, 'k' => 13}[rank.downcase] || rank.to_i) - 1
    return session.deck.cards[index]
  end
end
