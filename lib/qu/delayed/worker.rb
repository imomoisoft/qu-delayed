require 'qu-delayed'

module Qu
  module Delayed
    class Worker
      include Qu::Logger

      class Abort < Exception
      end

      def poll_frequency
        Qu.backend.poll_frequency
      end

      def handle_signals
        logger.debug "Sheduler #{id} registering traps for INT and TERM signals"
        %W(INT TERM).each do |sig|
          trap(sig) do
            logger.info "Sheduler #{id} received #{sig}, shutting down"
            raise Abort
          end
        end
      end

      def work(options = {:block => true})
        loop do
          logger.debug { "Getting next delayed job" }

          if payload = Qu.backend.next_delayed_job
            return Qu.backend.enqueue(payload)
          end

          if options[:block]
            sleep poll_frequency
          else
            break
          end
        end
      end

      def start
        logger.warn "Sheduler #{id} starting"
        handle_signals
        loop { work }
      rescue Abort => e
        # Ok, we'll shut down, but give us a sec
      ensure
        logger.debug "Sheduler #{id} done"
      end

      def id
        @id ||= "#{hostname}:#{pid}"
      end

      def pid
        @pid ||= Process.pid
      end

      def hostname
        @hostname ||= `hostname`.strip
      end
    end
  end
end
