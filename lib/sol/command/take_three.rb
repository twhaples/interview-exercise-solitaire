require 'sol/command'

class Sol::Command::TakeThree < Sol::Command
  def execute(session)
    if session.stack.size == 0
      session.stack.refresh(session.waste.recycle)
    else
      3.times do
        break unless session.stack.size > 0
        session.waste.add(session.stack.deal)
      end
    end
    return feedback
  end
end
