require 'qu/backend/mongo'

module Qu
  module Delayed
    module Backend
      module Mongo
        def enqueue_at(payload)
          payload_id = BSON::ObjectId.from_time(payload.run_at)
          delayed_jobs.insert({
                                :_id => payload_id,
                                :klass => payload.klass.to_s,
                                :queue => payload.queue,
                                :args => payload.args
                              })
          logger.debug { "Enqueued delayed job #{payload}" }
          payload
        end

        def next_delayed_job
          doc = delayed_jobs.find_and_modify(:query => {:_id => {'$lte' => BSON::ObjectId.from_time(Time.now) }}, :remove => true)
          return nil if doc.nil?

          enqueue(Qu::Delayed::Payload.new(doc).undelay)
        end

        def delayed_jobs
          self[:delayed_jobs]
        end

        def clear_delayed
          logger.info { "Clearing delayed jobs queue" }
          delayed_jobs.drop
        end
      end
    end
  end
end

Qu::Backend::Mongo.send :include, Qu::Delayed::Backend::Mongo
