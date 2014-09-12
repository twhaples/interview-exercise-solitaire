require 'rspec'
require 'rspec/expectations'
require 'sol/session'

RSpec::Matchers.define :be_card do |rank, suit|
  match do |card|
    card.rank == rank && card.suit == suit
  end
  failure_message do |actual|
    "expected #{rank} of #{suit} but got #{actual.rank} of #{actual.suit}"
  end
end

describe Sol::Session do
  describe '.new' do
    it 'should have a deck of cards, which start out in the stack' do
      game = described_class.new
      expect(game.deck.cards.length).to eq(52)
      expect(game.stack.cards.length).to eq(52)

      expect(game.faceup.map(&:size)).to eq([0] * 7)
      expect(game.facedown.map(&:size)).to eq([0] * 7)
      expect(game.discard.map(&:size)).to eq([0] * 4)
      expect(game.waste.size).to eq 0
    end
  end

  describe '#deal!' do
    it 'should take the cards off stack and put them in the piles' do
      game = described_class.new
      game.deal!

      expect(game.faceup[0].cards.first).to be_card(1, :clubs)
      expect(game.facedown[1].cards.first).to be_card(2, :clubs)
      expect(game.faceup[1].cards.first).to be_card(8, :clubs)

      expect(game.facedown.map {|p| p.cards.length }).to eq((0..6).to_a)
      expect(game.faceup.map {|p| p.cards.length }).to eq([1]*7)

      expect(game.deck.cards.reject {|c| c.pile == game.stack }.length).to eq((1..7).to_a.inject(:+))
    end
  end
end
