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
  let(:game) { described_class.new }
  describe '.new' do
    it 'should have a state' do
      expect(game.state).to eq(:preplay)
    end
    it 'should have a deck of cards, which start out in the stack' do
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
      game.deal!

      expect(game.faceup[0].cards.first).to be_card(1, :clubs)
      expect(game.facedown[1].cards.first).to be_card(2, :clubs)
      expect(game.faceup[1].cards.first).to be_card(8, :clubs)

      expect(game.facedown.map {|p| p.cards.length }).to eq((0..6).to_a)
      expect(game.faceup.map {|p| p.cards.length }).to eq([1]*7)

      expect(game.deck.cards.reject {|c| c.pile == game.stack }.length).to eq((1..7).to_a.inject(:+))
    end
  end

  describe '#start!' do
    it 'should shuffle the stack and deal (in that order)' do
      Test::Redef.rd(
        'Sol::Pile::Stack#shuffle!' => :wiretap,
        "#{described_class}#deal!" => :wiretap,
      ) do |rd|
        game.start!
        expect(rd.call_order).to eq(['Sol::Pile::Stack#shuffle!', "#{described_class}#deal!"])
      end
    end

    it 'should change the state' do
      expect { game.start! }.to change { game.state }.from(:preplay).to(:play)
    end

    it 'should only work once' do
      game.start!
      expect { game.start! }.to raise_error(ArgumentError)
    end
  end
end
