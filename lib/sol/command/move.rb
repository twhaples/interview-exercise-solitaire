require 'sol/command'

class Sol::Command::Move < Sol::Command
  attribute :card, String
  attribute :dest, String

  def execute(session)
    card = find_card(session)
    start_pile = card.pile
    destination = find_dest(session)
    
    cards = start_pile.pickup(card)
    destination.putdown(cards)

    start_pile.autoflip!
    return feedback
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
