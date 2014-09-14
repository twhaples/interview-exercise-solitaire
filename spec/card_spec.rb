require 'rspec'
require 'sol/card'

describe Sol::Card do
  describe '.new' do
    it 'should take a rank and a suit' do
      ace = described_class.new(1, :clubs)
      expect(ace.rank).to eq(1)
      expect(ace.suit).to eq(:clubs)
    end
  end
  describe '#color' do
    it 'should be the right color' do
      expect(described_class.new(nil, :clubs).color).to eq(:black)
      expect(described_class.new(77, :spades).color).to eq(:black)
      expect(described_class.new(0, :hearts).color).to eq(:red)
      expect(described_class.new("!", :diamonds).color).to eq(:red)
    end
  end
  describe '#to_s' do
    it 'should be a #{rank} of #{suit}' do
      two_hearts = described_class.new(2, :hearts)
      expect(two_hearts.to_s).to eq("2 of hearts")

      king_spades = described_class.new(13, :spades)
      expect(king_spades.to_s).to eq("13 of spades")

      ace_diamonds = described_class.new(1, :diamonds)
      expect(ace_diamonds.to_s).to eq ("1 of diamonds")
    end
  end 
end
