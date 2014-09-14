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
    let(:fake_stdout) { StringIO.new }
    let(:parser) { described_class.new(:input => io[0], :output => fake_stdout) }
    describe '#next' do
      it 'should quit on EOF' do
        write.close
        expect(parser.next).to be_a(Sol::Command::Quit)
      end
      it 'should quit on Q' do
        write.puts('Q')
        expect(parser.next).to be_a(Sol::Command::Quit)
      end
      it 'should include a prompt' do
        write.close
        expect { parser.next }.to change {fake_stdout.string}.to("> ")
      end
      it 'should restart on R' do
        write.puts('R')
        expect(parser.next).to be_a(Sol::Command::Restart)
      end
      it 'should handle multiple commands' do
        write.puts("R\nR\nR\nQ\nR")
        expect( (1..5).map { parser.next.class } ).to eq([
          Sol::Command::Restart,
          Sol::Command::Restart,
          Sol::Command::Restart,
          Sol::Command::Quit,
          Sol::Command::Restart,
        ])
        expect(fake_stdout.string).to eq("> " * 5)
      end
      it 'should handle nonsense' do
        write.puts("fish")
        expect(parser.next).to be_a(Sol::Command::Invalid)
      end
      it 'should handle empty strings' do
        write.puts
        expect(parser.next).to be_a(Sol::Command::Empty)
        write.puts("             ")
        expect(parser.next).to be_a(Sol::Command::Empty)
      end
      it 'should handle lowercase' do
        write.puts("r\nq")
        expect(parser.next).to be_a(Sol::Command::Restart)
        expect(parser.next).to be_a(Sol::Command::Quit)
      end
      it 'should handle the take-three command' do
        write.puts('T')
        expect(parser.next).to be_a(Sol::Command::TakeThree)
      end
      it 'should handle card->pile commands with minimal validation' do
        write.puts("ca 2")
        expect(parser.next).to eq(Sol::Command::Move.new(:card => 'ca', :dest => '2'))
        write.puts("xx x")
        expect(parser.next).to eq(Sol::Command::Move.new(:card => 'xx', :dest => 'x'))
        write.puts("xy \t z  ")
        expect(parser.next).to eq(Sol::Command::Move.new(:card => 'xy', :dest => 'z'))
      end
      it 'should not get confused by miscellaneous other invalid inputs' do
        write.puts("a man, a plan, a canal, panama")
        expect(parser.next).to be_a(Sol::Command::Invalid)
        write.puts("xx yy")
        expect(parser.next).to be_a(Sol::Command::Invalid)
        write.puts("x yz")
        expect(parser.next).to be_a(Sol::Command::Invalid)
      end
    end
  end
end
