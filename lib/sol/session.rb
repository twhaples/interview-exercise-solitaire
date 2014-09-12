require 'sol/deck'

module Sol; end
class Sol::Session
  attr_reader :deck
  attr_reader :stack

  def initialize
    @deck = Sol::Deck.new
    @stack = Sol::Pile.new
    @deck.cards.each {|c| @stack.add(c) }
  end
end
