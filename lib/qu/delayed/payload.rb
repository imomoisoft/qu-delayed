require 'ostruct'

module Qu
  module Delayed
    class Payload < Qu::Payload
      def perform
        Qu.enqueue(klass, args)
      end
    end
  end
end
