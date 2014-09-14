require 'rspec'
require 'sol/session'
require 'sol/command/take_three'

describe Sol::Command::TakeThree do
  describe '.new' do
    it 'should be boring' do
      expect(described_class.new).to be_truthy
    end
  end
  describe '#execute' do
    let(:session) { Sol::Session.new }
    let(:command) { described_class.new }
    let(:execute) { ->() { command.execute(session) } }
    context 'when Waste is empty and the Stack is full' do
      it 'should cause cards to move' do
        card = session.stack.cards[0]
        expect { execute.() }.to change { card.pile }.from(session.stack).to(session.waste)
      end
      it 'should move three cards into the Waste' do
        expect { execute.() }.to change { session.waste.size }.from(0).to(3)
      end
      it 'should move three cards out of the Stack' do
        expect { execute.() }.to change { session.stack.size }.by(-3)
      end
    end
    context 'when the Waste has all the cards' do
      before(:each) { 52.times { session.waste.add(session.stack.deal) }}
      it 'should recycle the waste into the stack' do
         expect { execute.() }.to change { session.stack.size }.from(0).to(52)
      end
    end
    context 'when Stack has only 2 cards' do
      before(:each) { 50.times { session.stack.deal } }
      it 'should move the cards it does have' do
        saved_cards = session.stack.cards.dup
        expect { execute.() }.to change { session.stack.size }.from(2).to(0)
        expect(session.waste.cards).to eq(saved_cards)
      end
    end
    context 'when the Stack and Waste are both empty' do
      before(:each) { 52.times { session.stack.deal } }
      it 'should do nothing' do
        expect { execute.() }.not_to raise_error
      end
    end
  end
end
