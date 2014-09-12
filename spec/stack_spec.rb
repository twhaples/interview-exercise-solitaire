require 'rspec'
require 'test/redef'
require 'sol/pile/stack'
require_relative './pile_examples'

describe Sol::Pile::Stack do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should be false' do
      # not that anyone asks yet, but, given the existence of the predicate
      # and the rules of the game in general this predicate should be false
      expect(described_class.new.visible?).to eq(false)
    end
  end

  describe '#shuffle!' do
    it 'calls .shuffle! on the array representing its cards' do
      deck = Sol::Deck.new
      stack = described_class.new
      deck.cards.each{|c| stack.add(c) }
      Test::Redef.rd 'Array#shuffle!' => :wiretap do |rd|
        stack.shuffle!
        expect(rd[:shuffle!].object).to eq([stack.cards])
      end
    end
  end
end
