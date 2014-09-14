require 'rspec'
require 'sol/pile/standard'
require_relative './pile_examples'

describe Sol::Pile::Standard do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should be true' do
      expect(described_class.new.visible?).to eq(true)
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
end
