require 'sol/command'
require 'sol/feedback'

class Sol::Command::Invalid < Sol::Command
  def execute(session)
    return feedback(:message => "Invalid command", :render => false)
  end
end
