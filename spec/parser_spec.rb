require 'rspec'
require 'sol/session'
require 'sol/commandparser'

describe Sol::CommandParser do
  describe '.identify_dest' do
    let(:session) { Sol::Session.new }
    it 'should identify a stack based on a token' do
      parser = described_class.new(:session => session)
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
      expect { parser.identify_dest('') }.to raise_error
      expect { parser.identify_dest('0') }.to raise_error
      expect { parser.identify_dest('8') }.to raise_error
      expect { parser.identify_dest('fish') }.to raise_error
      expect { parser.identify_dest('hello') }.to raise_error
    end 
  end
end
