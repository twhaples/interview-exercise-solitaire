require 'rspec'
require 'sol/bin'
require 'test/redef'

describe Sol::Bin do
  describe '.new' do
    it 'should connect its output to the console by default' do
      bin = Sol::Bin.new
      expect(bin.renderer).to be_a(Sol::Renderer)
      expect(bin.renderer.output).to eq(STDOUT)
    end
  end
  describe '#go!' do
    it 'should start a session and render it' do
      fake_stdout = StringIO.new
      render = Sol::Renderer.new(:output => fake_stdout)
      Test::Redef.rd('Sol::Renderer#render' => proc { 'pretty picture here' }) do |rd|
        Sol::Bin.new(:renderer => render).go! 
      end
      expect(fake_stdout.string).to eq("pretty picture here\n")
    end
  end 
end
