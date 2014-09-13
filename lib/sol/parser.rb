require 'virtus'

module Sol; end
class Sol::Parser
  include Virtus.model

  attribute :input, Object, :default => lambda {|_,_| STDIN }

  def next
    return :quit if input.eof?
    line = input.readline.tap(&:chomp!)
    case line
      when 'Q'; return :quit
      when 'R'; return :restart
    end
  end
end
