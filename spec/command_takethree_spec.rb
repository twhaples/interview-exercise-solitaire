require 'rspec'
require 'sol/command/take_three'

describe Sol::Command::TakeThree do
  describe 'new' do
    it 'should be boring' do
      expect(described_class.new).to be_truthy
    end
  end
end
