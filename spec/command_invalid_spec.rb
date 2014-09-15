require 'rspec'
require 'sol/command/invalid'

describe Sol::Command::Invalid do
  describe '#execute' do
    let(:feedback) { described_class.new.execute(nil) }
    it 'should not quit the current game' do
      expect(feedback.keep_playing).to eq(true)
    end
    it 'should not render the board again' do
      expect(feedback.render).to eq(false)
    end
    it 'should provide a helpful message' do
      expect(feedback.message).to eq('Invalid command')
    end
  end
end
