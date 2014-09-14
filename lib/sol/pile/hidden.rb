require 'sol/pile'

class Sol::Pile::Hidden < Sol::Pile
  def visible?; false; end

  def flip
    if cards.length > 0
      flipped = cards.pop
      flipped.pile = nil
      return flipped
    end
  end
end
