require 'rspec'
require 'sol/session'
require 'sol/card_command'

describe Sol::CardCommand do
  describe '#to_s' do
    it "should interpolate .card and .dest" do
      expect(described_class.new(:card => 'ac', :dest => 'x').to_s).to eq("move card ac to pile x")
    end
  end
  describe '#==' do
    let(:common_args) { {:card => 'aa', :dest => 'z'} }
    let(:common_cmd) { described_class.new(common_args) }
    it 'should return true for blank commands' do
      expect(described_class.new).to eq(described_class.new)
    end
    it 'should return true for equivalent commands' do
      expect(described_class.new(common_args)).to eq(common_cmd)
    end
    it 'should return false for different cards' do
      expect(described_class.new(common_args.merge(:card => 'ab'))).not_to eq(common_cmd)
    end
    it 'should return false for different destinations' do
      expect(described_class.new(common_args.merge(:dest => 'y'))).not_to eq(common_cmd)
    end
  end
  describe '#equal?' do
    it 'should not be fooled' do
      expect(described_class.new).not_to equal(described_class.new)
    end
  end
  describe '#identify_dest' do
    let(:session) { Sol::Session.new }
    let(:command) { described_class.new(:session => session) }
    it 'should identify a stack based on a token' do
      expect(command.identify_dest('1')).to eq(session.faceup[0])
      expect(command.identify_dest('2')).to eq(session.faceup[1])
      expect(command.identify_dest('3')).to eq(session.faceup[2])
      expect(command.identify_dest('4')).to eq(session.faceup[3])
      expect(command.identify_dest('5')).to eq(session.faceup[4])
      expect(command.identify_dest('6')).to eq(session.faceup[5])
      expect(command.identify_dest('7')).to eq(session.faceup[6])
      expect(command.identify_dest('d')).to eq(session.discard[0])
      expect(command.identify_dest('h')).to eq(session.discard[1])
      expect(command.identify_dest('c')).to eq(session.discard[2])
      expect(command.identify_dest('s')).to eq(session.discard[3])
      expect(command.identify_dest('D')).to eq(session.discard[0])
      expect(command.identify_dest('H')).to eq(session.discard[1])
      expect(command.identify_dest('C')).to eq(session.discard[2])
      expect(command.identify_dest('S')).to eq(session.discard[3])
    end
    it 'should raise errors on non-destination cards' do

      expect { command.identify_dest('') }.to raise_error
      expect { command.identify_dest('0') }.to raise_error
      expect { command.identify_dest('8') }.to raise_error
      expect { command.identify_dest('fish') }.to raise_error
      expect { command.identify_dest('hello') }.to raise_error
    end 
  end
  describe '#identify_card' do
    let(:session) { Sol::Session.new }
    let(:command) { described_class.new(:session => session) }
    it 'should match in lowercase' do
      expect(session.deck.cards.map do |card|
        short = Sol::Renderer._render_card(card).downcase
        command.identify_card(short).to_s
      end).to eq(session.deck.cards.map(&:to_s))
    end
    it 'should match in uppercase' do
      expect(session.deck.cards.map do |card|
        short = Sol::Renderer._render_card(card).upcase
        command.identify_card(short).to_s
      end).to eq(session.deck.cards.map(&:to_s))
    end
    it 'should raise errors on non-cards' do
      expect { command.identify_card('c0') }.to raise_error
      expect { command.identify_card('c1') }.to raise_error
      expect { command.identify_card('1c') }.to raise_error
      expect { command.identify_card('fish') }.to raise_error
      expect { command.identify_card('8') }.to raise_error
      expect { command.identify_card('f8') }.to raise_error
    end
  end
end
