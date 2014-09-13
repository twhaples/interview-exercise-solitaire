require 'rspec'
require 'sol/parser'

describe Sol::Parser do
  describe '.new' do
    it 'should read from stdin by default' do
      # fun fact: expecting STDIN to be equal to STDIN can hang.
      expect(described_class.new.input.fileno).to eq(STDIN.fileno)
    end
  end
  context 'parsing commands' do
    let(:io) { IO.pipe }
    let(:write) { io[1] }
    let(:parser) { described_class.new(:input => io[0]) }
    describe '#next' do
      it 'should return :quit on EOF' do
        write.close
        expect(parser.next).to eq(:quit)
      end
      it 'should return :quit on Q' do
        write.puts('Q')
        expect(parser.next).to eq(:quit)
      end
      it 'should return :restart on R' do
        write.puts('R')
        expect(parser.next).to eq(:restart)
      end
      it 'should handle multiple commands' do
        write.puts("R\nR\nR\nQ\nR")
        expect( (1..5).map { parser.next } ).to eq([
          :restart, :restart, :restart, :quit, :restart
        ])
      end
    end
  end
end
