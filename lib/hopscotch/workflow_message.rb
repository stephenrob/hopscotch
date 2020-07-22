require 'hopscotch/message'

module Hopscotch
  class WorkflowMessage < Message

    def initialize(workflow, workflow_id, message_type, message_version, message_id: nil, data: {}, meta: {})
      @workflow_id = workflow_id
      @workflow = workflow
      super(message_type, message_version, message_id: message_id, data: data, meta: meta.merge({workflow: @workflow, workflowId: @workflow_id}))
    end

    def self.from_message(message, workflow, workflow_id: SecureRandom.uuid)
      WorkflowMessage.new(workflow, workflow_id, message.message_type, message.message_version, message_id: message.message_id, data: message.data, meta: message.meta)
    end

  end
end