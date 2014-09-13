require 'sol/deck'
require 'sol/pile/simple'
require 'sol/pile/hidden'
require 'sol/pile/stack'

module Sol; end
class Sol::Session
  attr_reader :state # :preplay => :play => :victory
  attr_reader :deck  # all the cards

  attr_reader :stack # the thing you take 3 at a time from
  attr_reader :waste # the thing you put the 3 at a time onto

  attr_reader :faceup   # the ones you mostly work with
  attr_reader :facedown # the ones under the main piles
  attr_reader :discard  # the place you're trying to get all the cards

  def initialize
    @deck = Sol::Deck.new

    @stack = Sol::Pile::Stack.new
    @waste = Sol::Pile::Simple.new

    @deck.cards.each {|c| @stack.add(c) }

    @faceup = (0..6).map { Sol::Pile::Simple.new }
    @facedown = (0..6).map { Sol::Pile::Hidden.new }
    @discard = (0..3).map { Sol::Pile::Simple.new }

    @destinations = [*@faceup, *@discard]
    @state = :preplay
  end

  def start!
    raise ArgumentError unless @state == :preplay
    @stack.shuffle!
    deal!
    @state = :play
  end

  def deal!
    (0..6).each do |i_faceup|
      faceup[i_faceup].add(stack.deal)
      ((i_faceup+1)..6).each do |i|
        facedown[i].add(stack.deal)
      end
    end
  end

  def get_pile(type, i)
    {:faceup => @faceup, :discard => @discard}[type][i]
  end

  def execute(command)
  end
end
