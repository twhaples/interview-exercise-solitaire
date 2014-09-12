require 'rspec'
require 'sol/pile/simple'
require_relative './pile_examples'

describe Sol::Pile::Simple do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should be true' do
      expect(described_class.new.visible?).to eq(true)
    end
  end
end
