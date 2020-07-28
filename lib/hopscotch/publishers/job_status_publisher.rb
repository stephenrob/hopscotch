require 'hopscotch/publishers/system_message_publisher'

module Hopscotch
  module Publishers
    module JobStatusPublisher
      include SystemMessagePublisher

      def update_job_status(status)
        message = WorkflowMessage.new(workflow, workflow_id, 'hopscotch.system.job.statusUpdate', '0.1.0', data: {status: status}, meta: {job: self.class.to_s, runId: run_id})
        publish_system_message('hopscotch.system.job.statusUpdate', message)
      end

    end
  end
end