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

      parse_message_metadata(message.processed_message)

      logger.tagged(workflow: workflow, workflow_id: workflow_id, run_id: run_id, job: self.class.to_s) do

        logger.info("Starting run #{run_id} of workflow #{workflow} with id #{workflow_id}")

        update_job_status(Status::IN_PROGRESS)

        result = run(message)

        if result == :ack
          logger.info("Finished run #{run_id} of workflow #{workflow} with id #{workflow_id}")
          update_job_status(Status::COMPLETE)
        else
          update_job_status(Status::FAILED)
        end

        return result

      end

    end

    def run_id
      @run_id ||= SecureRandom.uuid
    end

    def workflow_id
      @workflow_id ||= SecureRandom.uuid
    end

    def workflow
      @workflow ||= "Standalone"
    end

    def parse_message_metadata(message)
      @workflow_id = message.meta[:workflowId]
      @workflow = message.meta[:workflow]
    end

  end
end