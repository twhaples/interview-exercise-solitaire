require 'sol/card'

module Sol; end
class Sol::Deck
  attr_reader :cards
  def initialize
    @cards = [:clubs, :diamonds, :spades, :hearts].map do |suit|
      (1..13).map {|rank| Sol::Card.new(rank, suit)}
    end.flatten
  end
end
