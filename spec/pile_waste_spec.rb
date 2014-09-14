require 'rspec'
require 'sol/pile/waste'
require 'sol/deck'
require_relative './pile_examples'

describe Sol::Pile::Waste do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should be true' do
      expect(described_class.new.visible?).to eq(true)
    end
  end

  describe '#pickup' do
    let(:pile) { described_class.new }
    let(:deck) { Sol::Deck.new }
    let(:starting_cards) { deck.cards.take(6) }
    before do
      starting_cards.each {|c| pile.add(c) }
    end

    let(:top_card) { starting_cards.last }
    it 'should let you take a single card from the top' do
      expect(pile.pickup(top_card)).to eq([starting_cards.last])
    end
    it "should null the card's pile" do
      expect { pile.pickup(top_card) }.to change {
        top_card.pile
      }.from(pile).to(nil)
    end
    it "should remove the card from the pile" do
      expect { pile.pickup(top_card) }.to change { 
        pile.cards
      }.from(starting_cards).to(starting_cards.take(5))
    end

    it "should not let you take a card that is not in it" do
      expect { pile.pickup(deck.cards.last) }.to raise_error
    end

    it "should not let you take cards in the middle" do
      expect { pile.pickup(starting_cards.first) }.to raise_error
      expect(pile.cards).to eq(starting_cards)
      expect(pile.cards.map(&:pile)).to eq([pile] * pile.size)
    end
  end
end
