require 'rspec'
require 'sol/bin'
require 'test/redef'

describe Sol::Bin do
  describe '.go!' do
    it 'should start a session and render it' do
      fake_stdout = StringIO.new
      Test::Redef.rd('Sol::Renderer#render' => proc { 'pretty picture here' }) do |rd|
        Sol::Bin.new(:output => fake_stdout).go! 
      end
      expect(fake_stdout.string).to eq("pretty picture here\n")
    end
  end 
end
