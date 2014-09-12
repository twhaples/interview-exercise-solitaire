require 'virtus'
require 'sol/session'
require 'sol/renderer'

module Sol; end
class Sol::Bin
  include Virtus.model

  attribute :session, Object, :default => lambda {|_,_| Sol::Session.new }
  attribute :renderer, Object, :default => lambda {|bin, _| Sol::Renderer.new(bin.session) }
  attribute :output, Object, :default => STDOUT
  def go!
    session.start!
    output.puts renderer.render 
  end
end
