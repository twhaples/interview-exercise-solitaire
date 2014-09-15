require 'virtus'
require 'sol/command/take_three'
require 'sol/command/restart'
require 'sol/command/quit'
require 'sol/command/empty'
require 'sol/command/invalid'
require 'sol/command/move'

module Sol; end
class Sol::Parser
  include Virtus.model

  # n.b. defer STDIN with a lambda, for convenience in testing
  #      (test harnesses like rspec can reopen STDIN, which means
  #       you can't compare STDIN assigned while a test is active to
  #       a STDIN assigned at require-time. joy!!)
  attribute :input, Object, :default => lambda {|_,_| STDIN }
  attribute :output, Object, :default => lambda {|_,_| STDOUT } # for prompts

  def next
    output << '> '
    return Sol::Command::Quit.new if input.eof?

    line = input.readline.tap(&:chomp!).tap(&:downcase!)
    case line
      when 'q'; return Sol::Command::Quit.new
      when 'r'; return Sol::Command::Restart.new
      when 't'; return Sol::Command::TakeThree.new
      when /\A\s*\Z/; return Sol::Command::Empty.new
      when /\A\s*(\S\S)\s*(\S)\s*\Z/
        return Sol::Command::Move.new(:card => $1, :dest => $2)
      else
        return Sol::Command::Invalid.new
    end
  end
end
