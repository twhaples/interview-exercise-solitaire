require 'sol'
require 'sol/feedback'
require 'virtus'

class Sol::Command
  include Virtus.model

  def feedback(args={})
    Sol::Feedback.new(args)
  end
end
