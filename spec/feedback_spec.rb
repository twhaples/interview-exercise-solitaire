require 'rspec'
require 'sol/feedback'

describe Sol::Feedback do
  describe '.new' do
    it 'should set defaults' do
      feedback = described_class.new
      expect(feedback.keep_playing).to be_truthy
      expect(feedback.play_again).to be_truthy
      expect(feedback.render).to be_truthy
      expect(feedback.message).to be_nil
    end
    it 'should take arguments' do
      feedback = described_class.new(
        :keep_playing => false,
        :play_again => false,
        :render => false,
        :message => 'hire me',
      )
      expect(feedback.keep_playing).to be_falsy
      expect(feedback.play_again).to be_falsy
      expect(feedback.render).to be_falsy
      expect(feedback.message).to eq('hire me')
    end
  end
end
