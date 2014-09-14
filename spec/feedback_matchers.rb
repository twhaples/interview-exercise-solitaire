require 'rspec'

RSpec::Matchers.define(:provide_boring_feedback) do
  match do |actual|
    actual.message.nil? && actual.render && actual.keep_playing
  end
  diffable
end

