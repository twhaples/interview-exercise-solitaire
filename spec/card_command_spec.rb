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
    let(:dest_for) { lambda do |token|
      described_class.new(:dest => token).find_dest(session)
    end }
    it 'should identify a stack based on a token' do
      expect(dest_for.('1')).to eq(session.faceup[0])
      expect(dest_for.('2')).to eq(session.faceup[1])
      expect(dest_for.('3')).to eq(session.faceup[2])
      expect(dest_for.('4')).to eq(session.faceup[3])
      expect(dest_for.('5')).to eq(session.faceup[4])
      expect(dest_for.('6')).to eq(session.faceup[5])
      expect(dest_for.('7')).to eq(session.faceup[6])
      expect(dest_for.('d')).to eq(session.discard[0])
      expect(dest_for.('h')).to eq(session.discard[1])
      expect(dest_for.('c')).to eq(session.discard[2])
      expect(dest_for.('s')).to eq(session.discard[3])
    end
    it 'should raise errors on non-destination piles' do
      expect { dest_for.('') }.to raise_error
      expect { dest_for.('0') }.to raise_error
      expect { dest_for.('8') }.to raise_error
      expect { dest_for.('fish') }.to raise_error
      expect { dest_for.('hello') }.to raise_error
    end
    it 'should raise errors on uppercase input' do
      expect { dest_for.('D') }.to raise_error
      expect { dest_for.('H') }.to raise_error
      expect { dest_for.('C') }.to raise_error
      expect { dest_for.('S') }.to raise_error
    end 
  end

  describe '#identify_card' do
    let(:session) { Sol::Session.new }
    let(:card_for) { lambda do |token|
      described_class.new(:card => token).find_card(session)
    end }
 
    it 'should match in lowercase' do
      expect(session.deck.cards.map do |card|
        short = Sol::Renderer._render_card(card).downcase
        card_for.(short).to_s
      end).to eq(session.deck.cards.map(&:to_s))
    end
    it 'should match in uppercase' do
      expect(session.deck.cards.map do |card|
        short = Sol::Renderer._render_card(card).upcase
        card_for.(short).to_s
      end).to eq(session.deck.cards.map(&:to_s))
    end

    it 'should raise errors on non-cards' do
      expect { card_for.('c0') }.to raise_error
      expect { card_for.('c1') }.to raise_error
      expect { card_for.('1c') }.to raise_error
      expect { card_for.('fish') }.to raise_error
      expect { card_for.('8') }.to raise_error
      expect { card_for.('f8') }.to raise_error
    end
  end
end
