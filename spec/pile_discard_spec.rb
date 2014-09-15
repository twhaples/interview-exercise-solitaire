require 'rspec'
require 'sol/pile/discard'
require_relative './pile_examples'

describe Sol::Pile::Discard do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should be true' do
      expect(described_class.new.visible?).to eq(true)
    end
  end

  describe '#can_putdown?' do
    let(:pile) { described_class.new }
    let(:club_ace) { Sol::Card.new(1, :clubs) }
    let(:club_2) { Sol::Card.new(2, :clubs) }
    let(:club_3) { Sol::Card.new(3, :clubs) }
    let(:diamond_2) { Sol::Card.new(2, :diamonds) }
    let(:diamond_ace) { Sol::Card.new(1, :diamonds) }
    context 'an empty pile' do
      it 'should be true for an ace' do
        expect(pile.can_putdown?([club_ace])).to eq(true)
      end
      it 'should be false for a non-ace' do
        expect(pile.can_putdown?([club_2])).to eq(false)
      end
      it 'should be true for a stack of ordered cards beginning with an ace' do
        expect(pile.can_putdown?([club_ace, club_2])).to eq(true)
      end
    end
    context 'on top of an existing card' do
      before { pile.add(club_ace) }
      it 'should be true for a card of same suit and next rank' do
        expect(pile.can_putdown?([club_2])).to eq(true)
      end
      it 'should be false for a card of different suit and next rank' do
        expect(pile.can_putdown?([diamond_2])).to eq(false)
      end
      it 'should be false for a card of same suit and the wrong rank' do
        expect(pile.can_putdown?([club_3])).to eq(false)
      end
      it 'should be true for a stack with the next few cards' do
        expect(pile.can_putdown?([club_2, club_3])).to eq(true)
      end 
      it 'should be false for a stack with the next card but then other cards' do
        expect(pile.can_putdown?([club_2, diamond_ace])).to eq(false)
      end
    end
  end
end
