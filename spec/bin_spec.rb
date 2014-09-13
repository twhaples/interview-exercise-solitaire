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
    it 'should be interpret commands like restart and quit but execute others' do
      fake_stdout = StringIO.new
      fake_render = FakeSol::Render.new

      fake_cmd_1 = FakeSol::Command.new
      fake_cmd_2 = FakeSol::Command.new

      fake_parser = FakeSol::Parser.new(:commands => [:restart, fake_cmd_1, fake_cmd_2, :quit])

      game = Sol::Bin.new(:renderer => fake_render, :parser => fake_parser)
      game.go!
      expect(fake_parser.commands).to eq([]) 
      expect(fake_render.rendered.length).to eq(4)

      game1, *games2 = *fake_render.rendered
      expect(games2.uniq.length).to eq 1
      game2 = games2.first

      expect(game1.to_s).not_to eq(game2.to_s)
      expect(game1).to be_a(Sol::Session)
      expect(game1.state).to eq(:play)

      expect(game2).to be_a(Sol::Session)
      expect(game2.state).to eq(:play)

      expect(fake_cmd_1.executions).to eq([game2])
      expect(fake_cmd_2.executions).to eq([game2])
    end
  end 
end

module FakeSol; end
class FakeSol::Command
  attr_reader :executions
  def initialize
    @executions = []
  end
  def execute(session)
    @executions << session
  end
end

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
