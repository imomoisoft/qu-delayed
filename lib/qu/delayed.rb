require 'qu'

require 'qu/delayed/payload'

module Qu
  module Delayed
    autoload :Worker, 'qu/delayed/worker'
    # Enqueues job to run at given time.
    def enqueue_at(run_at, klass, *args)
      backend.enqueue_at Qu::Delayed::Payload.new(:klass => klass, :run_at => run_at, :args => args)
    end

    # Enqueues job to run in +run_in+ seconds from now.
    def enqueue_in(run_in, klass, *args)
      backend.enqueue_at Qu::Delayed::Payload.new(:klass => klass, :run_at => Time.now + run_in, :args => args)
    end

    def clear_delayed
      backend.clear_delayed
    end
  end

  extend Delayed
end

if defined?(Rails)
  require 'qu/delayed/railtie' if defined?(Rails::Railtie)
end
