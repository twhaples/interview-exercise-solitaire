require 'virtus'

module Sol; end
class Sol::CommandParser
  include Virtus.model
  attribute :session, Object

  def identify_dest(token)
    if token =~ /\A[1-7]\Z/
      return self.session.get_pile(:faceup, token.to_i - 1)
    elsif (discard = {'d' => 0, 'h' => 1, 'c' => 2, 's' => 3}[token.downcase])
      return self.session.get_pile(:discard, discard)
    end
    raise ArgumentError
  end

  def identify_card(token)
    raise ArgumentError unless token =~ /[cdsh][A2-9TJKQ]/i
    suit, rank = token.split(//) 
    index = 13*['c','d', 's', 'h'].index(suit.downcase) + ({'a' => 1, 't' => 10, 'j' => 11, 'q' => 12, 'k' => 13}[rank.downcase] || rank.to_i) - 1
    return session.deck.cards[index]
  end
end
