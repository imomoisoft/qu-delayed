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

  module Backend
    class Immediate < Base
      include Delayed::Backend::Immediate
    end
  end
end

