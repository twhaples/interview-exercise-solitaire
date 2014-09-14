require 'virtus'

module Sol; end
class Sol::Feedback
  include Virtus.model

  attribute :render, Boolean, :default => true
  attribute :keep_playing, Boolean, :default => true
  attribute :play_again, Boolean, :default => true
  attribute :message, String
end
