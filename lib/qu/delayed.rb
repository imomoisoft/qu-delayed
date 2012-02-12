require 'qu'

require 'qu/delayed/payload'
require 'qu/delayed/worker'

module Qu
  module Delayed
    # Enqueues job to run at given time.
    def enqueue_at(run_at, klass, *args)
      backend.enqueue_at Qu::Delayed::Payload.new(:klass => klass, :run_at => run_at, :args => args)
    end

    # Enqueues job to run in +run_in+ seconds from now.
    def enqueue_in(run_in, klass, *args)
      backend.enqueue_at Qu::Delayed::Payload.new(:klass => klass, :run_at => Time.now + run_in, :args => args)
    end
  end

  extend Delayed
end
