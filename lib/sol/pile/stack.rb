require 'sol/pile'
class Sol::Pile::Stack < Sol::Pile
  def visible?; false; end
  def shuffle!; @cards.shuffle!; end
end
