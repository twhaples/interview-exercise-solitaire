require 'rspec'
require 'sol/command/quit'

describe Sol::Command::Quit do
  describe '#execute' do
    let(:feedback) { described_class.new.execute(nil) }
    it 'should quit the current game' do
      expect(feedback.keep_playing).to eq(false)
    end
    it 'should quit the whole game' do
      expect(feedback.play_again).to eq(false)
    end
  end
end
