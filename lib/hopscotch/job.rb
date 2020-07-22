require 'securerandom'

require 'hopscotch/producer'
require 'hopscotch/consumer'
require 'hopscotch/publishers/job_status_publisher'
require 'hopscotch/logger'

module Hopscotch
  class Job
    include Producer, Consumer, Publishers::JobStatusPublisher, Logger

    def run(_message)
      raise NotImplementedError
    end

    def handle(message)

      parse_message_metadata(message)

      update_job_status(Status::IN_PROGRESS)

      result = run(message)

      if result == :ack
        update_job_status(Status::COMPLETE)
      else
        update_job_status(Status::FAILED)
      end

      result

    end

    def run_id
      @run_id ||= SecureRandom.uuid
    end

    def workflow_id
      @workflow_id ||= 'Unknown'
    end

    def parse_message_metadata(message)
      @workflow_id = message.processed_message.message_id
    end

  end
end