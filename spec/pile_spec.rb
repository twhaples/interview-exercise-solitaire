require 'rspec'
require 'sol/pile'

describe Sol::Pile do
  describe '.new' do
    it 'should not have any cards' do
      pile = described_class.new
      expect(pile.cards).to eq([])
    end
  end
end
