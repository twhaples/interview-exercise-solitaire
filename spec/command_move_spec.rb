require 'rspec'
require 'sol/session'
require 'sol/renderer'
require 'sol/command/move'
require 'sol/command/take_three'
require_relative './feedback_matchers'

describe Sol::Command::Move do
  def move(spec)
    spec.each do |k, v|
      return described_class.new(:card => k, :dest => v).execute(session)
    end
  end
  def take3!
    Sol::Command::TakeThree.new.execute(session)
  end
  describe '#execute' do
    let(:session) { Sol::Session.new }
    let(:ace_of_clubs) { session.deck.cards.first }
    let(:ace_of_diamonds) { session.deck.cards[13] } 
    let(:nine_of_clubs) { session.deck.cards[8] } # under the ace of diamonds
    it 'should let you move cards around' do
      session.deal! # we're going to make use of an unshuffled layout a lot here
      expect { move('da' => '7') }.to provide_boring_feedback.and change {
        session.faceup[2].cards
      }.to([nine_of_clubs]).and change {
        session.faceup[6].size
      }.to(2).and change {
        ace_of_diamonds.pile
      }.from(session.faceup[2]).to(session.faceup[6]) 
    end

    it 'should not let you move cards to the wrong pile' do
      session.deal!
      expect { move('da' => '1') }.to complain('Invalid move')
      expect(ace_of_diamonds.pile).to eq(session.faceup[2]) # still
    end
    it 'should rely on pile.can_putdown?' do
      session.deal!
      Test::Redef.rd('Sol::Pile::Standard#can_putdown?' => proc { true }) do |rd|
        expect { move('da' => 1) }.to provide_boring_feedback.and change {
          ace_of_diamonds.pile
        }.from(session.faceup[2]).to(session.faceup[0])
        expect(rd.object).to eq([session.faceup[0]])
        expect(rd.args[0][0].map(&:to_s)).to eq([ace_of_diamonds.to_s])
      end
    end

    it 'should not let you take inaccessible cards' do
      # NO DEAL
      expect { move('ca' => 'c') }.to complain('Invalid move')
      expect(session.discard[2].size).to eq(0)       # still
      expect(ace_of_clubs.pile).to eq(session.stack) # still
    end
    it 'should rely on pile#can_pickup?' do
      session.deal!
      Test::Redef.rd('Sol::Pile::Standard#can_pickup?' => proc { false }) do |rd|
        expect { move('da' => 'd') }.to complain('Invalid move')
        expect(ace_of_diamonds.pile).to eq(session.faceup[2])
        expect(rd.object).to eq([session.faceup[2]])
        expect(rd.args[0].map(&:to_s)).to eq([ace_of_diamonds.to_s])
      end
    end

    context 'moving to the discard pile' do
      before { session.deal! }
      it 'should let you target an empty discard pile with a single ace' do
        expect { move('ca' => 'c') }.to provide_boring_feedback.and change {
          ace_of_clubs.pile
        }.from(session.faceup[0]).to(session.discard[2])
      end
      it 'should not let you target an empty discard pile with a non-ace' do
        # ugh, you can't chain negative matchers in rspec. you can't say expect{}.to not_change,
        # you can't say expect{}.not_to change {}.and_not change {}, you can't say 
        # expect{}.not_to change{}.or change{} ...
        expect { move('s2' => 's') }.not_to change {
         [session.deck.cards[2*13+1].pile, session.discard[3].cards, session.faceup[6].cards]
        }
      end
      it 'should tell you when you cannot target the discard pile with a non-ace' do
        expect(move('s2' => 's')).to complain("Invalid move")
      end
    end

    it 'should let you move the top card from the waste pile' do
      session.deal!
      take3!
      spade5 = session.waste.cards.last
      expect { move('s5' => '4') }.to change { spade5.pile }.from(session.waste).to(session.faceup[3])
    end

    it 'should let you move a stack of faceup cards' do
      cards = session.deck.cards
      stack3 = [cards[2], cards[13 + 1], cards[0] ]
      d4 = cards[13+3]
      #OMGHAX 
      d4.pile = nil
      stack3.each {|c| c.pile=nil; session.faceup[0].add(c) }
      #</OMGHAX> (back to regular hax)
      session.faceup[1].add(d4)

      # [1] 3c 2d Ac
      # [2] 4d
      expect { move('c3' => '2') }.to change { session.faceup[0].size }.from(3).to(0)
      expect(session.faceup[1].cards).to eq([d4, *stack3])
    end

    describe 'exposing hidden cards' do
      before { session.deal! }
      let(:club3) { session.deck.cards[2] }
      let(:club9) { session.deck.cards[8] }
      let(:diamondA) { session.deck.cards[13] }
      let(:expose) { lambda do; move('da' => 'd'); end }
      # Move the diamond ace to the diamond discard pile, exposing the club-9 underneath.

      it 'should change card.pile' do
        expect { expose.() }.to change { club9.pile }.from(session.facedown[2]).to(session.faceup[2])
      end
      it 'should remove the card from the old pile' do
        expect { expose.() }.to change { session.facedown[2].cards }.from([club3, club9]).to([club3])
      end
      it 'should put the card on the new pile' do
        expect { expose.() }.to change { session.faceup[2].cards }.from([diamondA]).to([club9])
      end 

      it 'should work when the pile is empty' do
        expect { move('ca' => 'c') }.not_to raise_error
      end
    end

    it 'should be nice about invalid commands' do
      expect(move('zz' => '1')).to complain('Invalid card')
      expect(move('ac' => '1')).to complain('Invalid card')
      expect(move('ca' => '0')).to complain('Invalid destination')
      expect(move('ca' => '123')).to complain('Invalid destination')
    end
  end

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
    it 'should return nil on non-destination piles' do
      expect(dest_for.('')).to be_nil
      expect(dest_for.('0')).to be_nil
      expect(dest_for.('fish')).to be_nil
      expect(dest_for.('8')).to be_nil
      expect(dest_for.('t')).to be_nil
      expect(dest_for.('hello')).to be_nil
    end
    it 'should return nil on uppercase input' do
      expect(dest_for.('D')).to be_nil
      expect(dest_for.('H')).to be_nil
      expect(dest_for.('C')).to be_nil
      expect(dest_for.('S')).to be_nil
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

    it 'should return nil on non-cards' do
      expect(card_for.('c0')).to be_nil
      expect(card_for.('c1')).to be_nil
      expect(card_for.('1c')).to be_nil
      expect(card_for.('fish')).to be_nil
      expect(card_for.('8')).to be_nil
      expect(card_for.('f8')).to be_nil
    end
  end
end
