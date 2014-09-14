require 'rspec'
require 'sol/card'
require 'sol/pile'
require 'sol/session'
require 'sol/renderer'

describe Sol::Renderer do
  describe '.render_card' do
    it 'should render visible cards right' do
      pile = Sol::Pile::Standard.new
      expect(Sol::Deck.new.cards.map do |c| 
        pile.add(c)
        described_class.render_card(c)
      end.join("\n")).to eq(%w{
        cA c2 c3 c4 c5 c6 c7 c8 c9 cT cJ cQ cK
        DA D2 D3 D4 D5 D6 D7 D8 D9 DT DJ DQ DK
        sA s2 s3 s4 s5 s6 s7 s8 s9 sT sJ sQ sK
        HA H2 H3 H4 H5 H6 H7 H8 H9 HT HJ HQ HK
      }.join("\n"))
    end

    it 'should render invisible cards right' do
      pile = Sol::Pile::Hidden.new
      expect(Sol::Deck.new.cards.map do |c| 
        pile.add(c)
        described_class.render_card(c)
      end).to eq(['**'] * 52) 
    end

    it 'should not render cards outside of piles' do
      expect {
        described_class.render_card(Sol::Card.new(1, :clubs))
      }.to raise_error
    end
  end
  describe '.new.to_s' do
    it 'should turn a session into plaintext' do
      session = Sol::Session.new
      renderer = described_class.new(:session => session)
      expect(renderer.render).to eq(<<EOT.chomp
[sTack] [1] [2] [3] [4] [5] [6] [7] [D] [H] [c] [s]
EOT
      )
     
      session.deal!
      screen = renderer.render
      expected = <<EOT.chomp
[sTack] [1] [2] [3] [4] [5] [6] [7] [D] [H] [c] [s]
        cA  **  **  **  **  **  **                
            c8  **  **  **  **  **                
                DA  **  **  **  **                
                    D6  **  **  ** 
                        DT  **  **
                            DK  **                 
                                s2               
EOT
      screen.gsub!(/\s+$/m, '')
      expected.gsub!(/\s+$/m, '') 
      expect(screen).to eq(expected)
    end
  end
  describe '#render!' do
    it 'should puts data to the appropriate filehandle' do
      session = Sol::Session.new.tap(&:start!)
      fake_stdout = StringIO.new
      renderer = described_class.new(:output => fake_stdout, :session => session)
      renderer.render!
      expect(fake_stdout.string).to eq(renderer.render + "\n")
    end
  end
  describe '#message!' do
    it 'should communicate a helpful message to the appropriate filehandle' do
      fake_stdout = StringIO.new
      renderer = described_class.new(:output => fake_stdout)
      message = "tom is an excellent programmer you should hire him"
      expect { renderer.message!(message) }.to change { fake_stdout.string }.to(message + "\n")
    end
  end
end
