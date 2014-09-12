require 'rspec'
require 'sol/deck'

describe Sol::Deck do
  describe '.new' do
    it 'should have all the cards' do
      deck = described_class.new
      expect(deck.cards.length).to eq(52)
      expect(deck.cards.map(&:rank)).to eq((1..13).to_a() * 4)
      expect(deck.cards.map(&:suit)).to eq([
        [:clubs] * 13,
        [:diamonds] * 13,
        [:spades] * 13,
        [:hearts] * 13,
      ].flatten)
    end
  end
end
