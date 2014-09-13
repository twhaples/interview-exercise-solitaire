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
    play_again = true
    while play_again do
      session = Sol::Session.new
      session.start!
      renderer.session = session
      keep_playing = true
      while keep_playing do
        renderer.render!
        command = parser.next
        case command
          when :quit
            keep_playing = false
            play_again = false
          when :restart
            keep_playing = false
          else
            session.execute(command)
        end
      end
    end
  end
end
