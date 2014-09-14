require 'virtus'

module Sol; module Command; end end
class Sol::Command::TakeThree
  def execute(session)
    if session.stack.size == 0
      session.stack.refresh(session.waste.recycle)
    else
      3.times do
        break unless session.stack.size > 0
        session.waste.add(session.stack.deal)
      end
    end
  end
end
