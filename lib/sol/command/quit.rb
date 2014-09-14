require 'sol/command'

class Sol::Command::Quit < Sol::Command
  def execute(session)
    return feedback(:keep_playing => false, :play_again => false)
  end
end
