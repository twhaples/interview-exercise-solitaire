require 'virtus'

module Sol; end
class Sol::Parser
  include Virtus.model

  attribute :input, Object, :default => STDOUT

end
