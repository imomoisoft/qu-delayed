require 'qu'

require 'qu/delayed/payload'

module Qu
  module Delayed
    def enqueue_at(run_at, klass, *args)
      backend.enqueue_at Qu::Delayed::Payload.new(:klass => klass, :run_at => run_at, :args => args)
    end

    def enqueue_in(run_in, klass, *args)
      backend.enqueue_at Qu::Delayed::Payload.new(:klass => klass, :run_at => Time.now + run_in, :args => args)
    end

    def clear_delayed_queue
    end
  end

  extend Delayed
end
