require 'ostruct'

module Qu
  module Delayed
    class Payload < Qu::Payload

      def initialize(options = {})
        super
        unless _id.nil?
          self.run_at ||= _id.generation_time
        end
      end

      def perform
        Qu.enqueue(klass, args)
      end

      def to_s
        "#{run_at.to_i}:#{super}"
      end

      def undelay
        Qu::Payload.new(:klass => klass, :args => args)
      end
    end
  end
end
