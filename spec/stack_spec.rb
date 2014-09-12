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

  describe '#deal' do
    it 'should take the first card' do
      all_diamonds = (1..13).map {|r| Sol::Card.new(r, :diamonds)}

      pile = described_class.new
      all_diamonds.each {|d| pile.add(d) }
      expect(pile.size).to eq 13

      dealt = pile.deal
      expect(dealt).to eq(all_diamonds[0])
      expect(pile.size).to eq 12

      dealt = pile.deal
      expect(dealt).to eq(all_diamonds[1])
      expect(pile.size).to eq 11
    end
    it 'should complain if it runs empty' do
      pile = described_class.new
      pile.add(Sol::Card.new(99, :fish))
      pile.deal
      expect { pile.deal }.to raise_error(ArgumentError)
    end
  end
end
