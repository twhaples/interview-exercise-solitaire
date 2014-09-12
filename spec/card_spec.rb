require 'rspec'
require 'sol/card'

describe Sol::Card do
  describe '.new' do
    it 'should take a rank and a suit' do
      ace = described_class.new(1, :club)
      expect(ace.rank).to eq(1)
      expect(ace.suit).to eq(:club)
    end
  end
end
