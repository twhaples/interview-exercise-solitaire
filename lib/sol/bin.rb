require 'virtus'
require 'sol/session'
require 'sol/renderer'
require 'sol/parser'

module Sol; end
class Sol::Bin
  include Virtus.model

  attribute :renderer, Object, :default => lambda {|_, _| Sol::Renderer.new(:output => STDOUT) }
  attribute :parser, Object, :default => lambda {|_, _| Sol::Parser.new(:input => STDIN) }
  def go!
    feedback = Sol::Feedback.new
    while feedback.play_again do
      session = Sol::Session.new
      session.start!
      renderer.session = session
      feedback = Sol::Feedback.new
      while feedback.keep_playing do
        renderer.render! if feedback.render
        command = parser.next
        feedback = command.execute(session)
        renderer.message!(feedback.message) if feedback.message
      end
    end
  end
end
