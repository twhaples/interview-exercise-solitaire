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
end
