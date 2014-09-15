require 'rspec'
require 'sol/command/restart'

describe Sol::Command::Restart do
  describe '#execute' do
    let(:feedback) { described_class.new.execute(nil) }
    it 'should quit the current game' do
      expect(feedback.keep_playing).to eq(false)
    end
    it 'should not quit the whole game' do
      expect(feedback.play_again).to eq(true)
    end
  end
end
