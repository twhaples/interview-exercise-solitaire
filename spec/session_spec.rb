require 'rspec'
require 'sol/session'

describe Sol::Session do
  describe '.new' do
    it 'should have a deck of cards, which start out in the stack' do
      game = described_class.new
      expect(game.deck.cards.length).to eq(52)
      expect(game.stack.cards.length).to eq(52)
    end
  end
end
