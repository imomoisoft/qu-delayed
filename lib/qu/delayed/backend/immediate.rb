require 'qu/backend/immediate'

module Qu
  module Delayed
    module Backend
      module Immediate
        def enqueue_at(payload)
          payload.perform
        end
      end
    end
  end
end

Qu::Backend::Immediate.send :include, Qu::Delayed::Backend::Immediate
