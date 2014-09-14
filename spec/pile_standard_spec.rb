require 'rspec'
require 'sol/deck'
require 'sol/pile/standard'
require 'sol/pile/hidden'
require_relative './pile_examples'

describe Sol::Pile::Standard do
 it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should be true' do
      expect(described_class.new.visible?).to eq(true)
    end
  end

  let(:heart) { 3*13-1 }
  let(:spade) { 2*13-1 }
  let(:diamond) { 13-1 }
  let(:club) { -1 }
  let(:king) { 13 }
  let(:queen) { 12 }
  let(:jack) { 11 } 

  describe '#can_putdown?' do
    let(:pile) { described_class.new }
    let(:cards) { Sol::Deck.new.cards }
    context 'an empty pile' do
      it 'should be true for a king' do
        expect(cards[club+king].rank).to be(13)

        expect(pile.can_putdown?([cards[club+king]])).to be(true)
        expect(pile.can_putdown?([cards[diamond+king]])).to be(true) 
        expect(pile.can_putdown?([cards[heart+king]])).to be(true)
        expect(pile.can_putdown?([cards[spade+king]])).to be(true)
      end
      it 'should be true for an alternating king/queen/jack stack' do
        expect(pile.can_putdown?([
          cards[club+king], 
          cards[diamond+queen], 
          cards[spade+jack]
        ])).to be(true)
        expect(pile.can_putdown?([
          cards[heart+king], 
          cards[club+queen], 
          cards[heart+jack]
        ])).to be(true)
      end

      it 'should be false for an invalid stack' do
        expect(pile.can_putdown?([
          cards[club+king],
          cards[spade+queen],
          cards[club+jack]
        ])).to be(false)
      end
    end
    context 'on top of some cards' do
      before do
        pile.add(cards[spade+6])
        pile.add(cards[diamond+5])
      end
      it 'should be true for the right rank of opposite color' do
        expect(pile.can_putdown?([cards[club+4]])).to be(true)
        expect(pile.can_putdown?([cards[spade+4]])).to be(true)
      end
      it 'should be false for the right rank of same color' do
        expect(pile.can_putdown?([cards[diamond+4]])).to be(false)
        expect(pile.can_putdown?([cards[heart+4]])).to be(false)
      end
      it 'should be false for the wrong rank of the opposite color' do
        expect(pile.can_putdown?([cards[club+3]])).to be(false)
        expect(pile.can_putdown?([cards[club+5]])).to be(false)
      end
      it 'should be true for a proper stack' do
        expect(pile.can_putdown?([
          cards[club+4], 
          cards[diamond+3], 
          cards[spade+2]
        ])).to be(true)
      end
      it 'should be false for a non-alternating stack' do
        expect(pile.can_putdown?([
          cards[diamond+4], 
          cards[club+3], 
          cards[heart+2]
        ])).to be(false)
      end
      it 'should be false for a stack that tries to wrap around' do
        expect(pile.can_putdown?([
          cards[club+4],
          cards[diamond+3],
          cards[spade+2],
          cards[diamond+1],
          cards[club+king]
        ])).to be(false)
      end
    end
  end

  describe '#pickup' do
    let(:deck) { Sol::Deck.new }
    let(:club_ace) { deck.cards[0] }
    let(:club_3) { deck.cards[2] }
    let(:diamond_2) { deck.cards[13+1] }
    let(:diamond_4) { deck.cards[13+3] }

    let(:pile) do
      described_class.new.tap do |pile|
        [diamond_4, club_3, diamond_2, club_ace].each do |c| 
          pile.add(c)
        end
      end
    end

    it 'should return a single card' do
      expect(pile.pickup(club_ace)).to eq([club_ace])
    end
    it 'should null card.pile' do
      expect { pile.pickup(club_ace) }.to change {
        club_ace.pile
      }.from(pile).to(nil)
    end
    it 'should remove the card' do
      expect { pile.pickup(club_ace) }.to change {
        pile.cards.include?(club_ace)
      }.from(true).to(false)
    end

    it 'should return multiple cards' do
      expect(pile.pickup(diamond_4)).to eq([diamond_4, club_3, diamond_2, club_ace])
    end
    it 'should remove multiple cards' do
      expect { pile.pickup(club_3) }.to change { pile.cards.length }.from(4).to(1)
    end

    it 'should not let you remove cards which are not present' do
      expect { pile.pickup(deck.cards.last) }.to raise_error
    end
  end

  describe '#autoflip!' do
    let(:deck) { Sol::Deck.new }
    let(:facedown) { Sol::Pile::Hidden.new }
    let(:pile) { described_class.new(:facedown => facedown) }
    context 'when the pile is not empty' do
      before do
        pile.add(deck.cards[0])
        facedown.add(deck.cards[1])
      end
      it 'should not add cards to itself' do
        expect { pile.autoflip! }.not_to change { pile.cards }
      end
      it 'should not remove cards from the facedown pile' do
        expect { pile.autoflip! }.not_to change { facedown.cards }
      end
    end
    context 'when the pile is empty but there are facedown cards' do
      let(:top_card) { deck.cards[9] }
      before do
        facedown.add(deck.cards[2])
        facedown.add(deck.cards[33])
        facedown.add(top_card)
      end
      it 'should move the top card' do
        expect { pile.autoflip! }.to change { top_card.pile }.from(facedown).to(pile)
      end

      it 'should add the card to itself' do
        expect { pile.autoflip! }.to change { pile.cards }.from([]).to([top_card])
      end
    end
    context 'when both piles are empty' do
      it 'should do nothing' do
        expect { pile.autoflip! }.not_to change { pile.cards }.from([])
      end
    end
  end
end
