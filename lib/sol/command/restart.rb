require 'sol/command'

class Sol::Command::Restart < Sol::Command
  def execute(session)
    return feedback(:keep_playing => false)
  end
end
