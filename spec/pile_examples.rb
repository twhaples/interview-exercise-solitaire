require 'sol/card'

RSpec.shared_examples 'a pile' do
  let(:ace_of_clubs) { Sol::Card.new(1, :clubs) }
  let(:queen_of_spades) { Sol::Card.new(12, :spades) }
  let(:all_diamonds) { (1..13).map {|r| Sol::Card.new(r, :diamonds)} }
 
  describe '.new' do
    it 'should not have any cards' do
      pile = described_class.new
      expect(pile.cards).to eq([])
      expect(pile.size).to eq 0
    end
  end

  describe '#add' do
   let(:pile) { described_class.new }
   it 'should take a card (or two)' do
      pile.add(ace_of_clubs)
      expect(pile.cards).to eq([ace_of_clubs])
      expect(pile.size).to eq 1

      pile.add(queen_of_spades)
      expect(pile.cards).to eq([ace_of_clubs, queen_of_spades])
      expect(pile.size).to eq 2
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

  describe '#remove' do
    it 'should take the first card' do
      pile = described_class.new
      all_diamonds.each {|d| pile.add(d) }
      expect(pile.size).to eq 13

      removed = pile.remove
      expect(removed).to eq(all_diamonds[0])
      expect(pile.size).to eq 12

      removed = pile.remove
      expect(removed).to eq(all_diamonds[1])
      expect(pile.size).to eq 11
    end
    it 'should complain if empty' do
      pile = described_class.new
      pile.add(ace_of_clubs)
      pile.remove
      expect { pile.remove }.to raise_error(ArgumentError)
    end
  end
end
