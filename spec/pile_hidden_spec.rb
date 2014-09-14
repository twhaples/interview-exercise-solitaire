require 'rspec'
require 'sol/pile/hidden'
require_relative './pile_examples'

describe Sol::Pile::Hidden do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should just be true' do
      expect(described_class.new.visible?).to eq(false)
    end
  end

  describe '#flip' do
    context 'when there are no cards' do
      it 'should return nil' do
        expect(described_class.new.flip).to be_nil
      end
    end
    context 'when there are cards' do
      let(:deck) { Sol::Deck.new }
      let(:starting_cards) { [deck.cards[4], deck.cards[13], deck.cards[42]] }
      let(:pile) { described_class.new.tap {|p| starting_cards.each{|c| p.add(c)} } }
      it 'should return the top card' do
        expect(pile.flip).to eq(starting_cards.last)
      end
      it 'should remove the last card' do
        expect { pile.flip }.to change {
          pile.cards
        }.from(starting_cards).to(starting_cards[0..-2])
      end
      it 'should change card.pile' do
        expect { pile.flip }.to change { 
          starting_cards.last.pile
        }.from(pile).to(nil)
      end
    end
  end
end
