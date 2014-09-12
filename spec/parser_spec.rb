require 'rspec'
require 'sol/session'
require 'sol/commandparser'

describe Sol::CommandParser do
  let(:session) { Sol::Session.new }
  let(:parser) { described_class.new(:session => session) }
  describe '#identify_dest' do
    it 'should identify a stack based on a token' do
      expect(parser.identify_dest('1')).to eq(session.faceup[0])
      expect(parser.identify_dest('2')).to eq(session.faceup[1])
      expect(parser.identify_dest('3')).to eq(session.faceup[2])
      expect(parser.identify_dest('4')).to eq(session.faceup[3])
      expect(parser.identify_dest('5')).to eq(session.faceup[4])
      expect(parser.identify_dest('6')).to eq(session.faceup[5])
      expect(parser.identify_dest('7')).to eq(session.faceup[6])
      expect(parser.identify_dest('d')).to eq(session.discard[0])
      expect(parser.identify_dest('h')).to eq(session.discard[1])
      expect(parser.identify_dest('c')).to eq(session.discard[2])
      expect(parser.identify_dest('s')).to eq(session.discard[3])
      expect(parser.identify_dest('D')).to eq(session.discard[0])
      expect(parser.identify_dest('H')).to eq(session.discard[1])
      expect(parser.identify_dest('C')).to eq(session.discard[2])
      expect(parser.identify_dest('S')).to eq(session.discard[3])
    end
    it 'should raise errors on non-destination cards' do
      expect { parser.identify_dest('') }.to raise_error
      expect { parser.identify_dest('0') }.to raise_error
      expect { parser.identify_dest('8') }.to raise_error
      expect { parser.identify_dest('fish') }.to raise_error
      expect { parser.identify_dest('hello') }.to raise_error
    end 
  end
  describe '#identify_card' do
    it 'should match in lowercase' do
      expect(session.deck.cards.map do |card|
        short = Sol::Renderer._render_card(card).downcase
        parser.identify_card(short).to_s
      end).to eq(session.deck.cards.map(&:to_s))
    end
    it 'should match in uppercase' do
      expect(session.deck.cards.map do |card|
        short = Sol::Renderer._render_card(card).upcase
        parser.identify_card(short).to_s
      end).to eq(session.deck.cards.map(&:to_s))
    end
    it 'should raise errors on non-cards' do

      expect { parser.identify_card('c0') }.to raise_error
      expect { parser.identify_card('c1') }.to raise_error
      expect { parser.identify_card('1c') }.to raise_error
      expect { parser.identify_card('fish') }.to raise_error
      expect { parser.identify_card('8') }.to raise_error
      expect { parser.identify_card('f8') }.to raise_error
    end
  end
end
