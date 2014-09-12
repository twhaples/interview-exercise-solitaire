require 'virtus'

module Sol; end
class Sol::CommandParser
  include Virtus.model
  attribute :session, Object

  def identify_dest(token)
    if token =~ /\A[1-7]\Z/
      return session.get_pile(:faceup, token.to_i - 1)
    elsif (discard = {'d' => 0, 'h' => 1, 'c' => 2, 's' => 3}[token.downcase])
      return session.get_pile(:discard, discard)
    end
    raise ArgumentError
  end
end
