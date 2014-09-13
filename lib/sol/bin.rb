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
    session = Sol::Session.new
    session.start!
    renderer.session = session
    renderer.render! 
  end
end
