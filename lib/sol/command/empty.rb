require 'sol/command'

class Sol::Command::Empty < Sol::Command
  def execute(session)
    return feedback(:render => false)
  end
end
