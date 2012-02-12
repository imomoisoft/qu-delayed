require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'rspec'
  require 'qu/backend/spec'
  require 'timecop'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    config.before do
      Qu.backend = mock('a backend', :reserve => nil, :failed => nil, :completed => nil,
        :register_worker => nil, :unregister_worker => nil)
      Qu.failure = nil
    end
  end
end

Spork.each_run do
  require 'qu-delayed'
end

