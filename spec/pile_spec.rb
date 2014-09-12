require 'rspec'
require 'sol/pile'
require 'sol/card'

describe Sol::Pile do
  describe '.new' do
    it 'should not have any cards' do
      pile = described_class.new
      expect(pile.cards).to eq([])
    end
  end

  describe '.add' do
    let(:pile) { described_class.new }
    let(:ace_of_clubs) { Sol::Card.new(1, :clubs) }
    let(:queen_of_spades) { Sol::Card.new(12, :spades) }
    it 'should take a card (or two)' do
      pile.add(ace_of_clubs)
      expect(pile.cards).to eq([ace_of_clubs])
      pile.add(queen_of_spades)
      expect(pile.cards).to eq([ace_of_clubs, queen_of_spades])
    end

    it 'should not take the same card twice' do
      pile.add(ace_of_clubs)
      expect {
        pile.add(ace_of_clubs)
      }.to raise_error(ArgumentError)
    end

    it 'should not take a card belonging to a different pile' do
      pile2 = described_class.new
      pile2.add(queen_of_spades)
      expect {
        pile.add(queen_of_spades)
      }.to raise_error(ArgumentError)
    end
  end
end
