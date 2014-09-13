require 'rspec'
require 'sol/pile/hidden'
require_relative './pile_examples'

describe Sol::Pile::Hidden do
  it_behaves_like 'a pile'
  describe '#visible?' do
    it 'should just be true' do
      expect(described_class.new.visible?).to eq(false)
    end
  end
end
