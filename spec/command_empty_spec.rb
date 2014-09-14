require 'rspec'
require 'sol/command/empty'

describe Sol::Command::Empty do
  describe '#execute' do
    let(:feedback) { described_class.new.execute(nil) }
    it 'should not quit the current game' do
      expect(feedback.keep_playing).to eq(true)
    end
    it 'should not render again' do
      expect(feedback.render).to eq(false)
    end
    it 'should have no message' do
      expect(feedback.message).to be_nil
    end
  end
end
