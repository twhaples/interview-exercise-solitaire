require 'virtus'
require 'sol/card_command'

module Sol; end
class Sol::Parser
  include Virtus.model

  # n.b. defer STDIN with a lambda, for convenience in testing
  #      (test harnesses like rspec can reopen STDIN, which means
  #       you can't compare STDIN assigned while a test is active to
  #       a STDIN assigned at require-time. joy!!)
  attribute :input, Object, :default => lambda {|_,_| STDIN }

  def next
    return :quit if input.eof?
    line = input.readline.tap(&:chomp!).tap(&:downcase!)
    case line
      when 'q'; return :quit
      when 'r'; return :restart
      when /\A\s*\Z/; return nil
      when /\A\s*(\S\S)\s*(\S)\s*\Z/
        return Sol::CardCommand.new(:card => $1, :dest => $2)
      else
        return :invalid
    end
  end
end
