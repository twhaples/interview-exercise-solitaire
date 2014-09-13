require 'rspec'
require 'virtus'
require 'sol/bin'
require 'test/redef'

describe Sol::Bin do
  describe '.new' do
    it 'should connect its output to the console by default' do
      bin = Sol::Bin.new
      expect(bin.renderer).to be_a(Sol::Renderer)
      expect(bin.renderer.output).to eq(STDOUT)

      expect(bin.parser).to be_a(Sol::Parser)
      expect(bin.parser.input).to eq(STDIN)
    end
  end

  describe '#go!' do
    it 'should be interpret commands like restart and quit but pass others to the session' do
      fake_stdout = StringIO.new
      fake_render = FakeSol::Render.new
      fake_parser = FakeSol::Parser.new(:commands => [:restart, :banana, :fish, :quit])

      game = Sol::Bin.new(:renderer => fake_render, :parser => fake_parser)
      Test::Redef.rd('Sol::Session#execute' => :wiretap) do |rd|
        game.go!

        expect(fake_parser.commands).to eq([]) 
        expect(fake_render.rendered.length).to eq(4)

        game1, *games2 = *fake_render.rendered
        expect(games2.uniq.length).to eq 1
        game2 = games2.first

        expect(rd[:execute].object.map(&:to_s)).to eq([game2, game2].map(&:to_s))
        expect(rd[:execute].args).to eq([[:banana], [:fish]]) 

        expect(game1.to_s).not_to eq(game2.to_s)
        expect(game1).to be_a(Sol::Session)
        expect(game1.state).to eq(:play)

        expect(game2).to be_a(Sol::Session)
        expect(game2.state).to eq(:play)
      end
    end
  end 
end

module FakeSol; end
class FakeSol::Render
  attr_accessor :session
  attr_accessor :rendered
  def initialize
    @rendered = []
  end
  def render!
    @rendered << session
  end
end
class FakeSol::Parser
  include Virtus.model
  attribute :commands
  def next
    return @commands.shift
  end
end 
