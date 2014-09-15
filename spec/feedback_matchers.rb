require 'rspec'

RSpec::Matchers.define(:provide_boring_feedback) do
  match do |actual|
    actual = actual.call if actual.respond_to?(:call) # eww.
    actual.message.nil? && actual.render && actual.keep_playing
  end
  
  diffable
  supports_block_expectations
end

RSpec::Matchers.define(:complain) do |complaint|
  match do |actual|
    actual = actual.call if actual.respond_to?(:call) # eww <x2>
    actual.message == complaint && !actual.render && actual.keep_playing
  end
  diffable
  supports_block_expectations
end
