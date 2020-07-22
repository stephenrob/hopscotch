require 'hopscotch/publishers/system_message_publisher'
require 'hopscotch/message'

module Hopscotch
  module Publishers
    module CreateWorkflowPublisher
      include SystemMessagePublisher

      def create_workflow(workflow, params)
        message = Message.new('hopscotch.system.workflow.create', '0.1.0', data: {workflow: {name: workflow, params: params}})
        publish_system_message('hopscotch.system.workflow.create', message)
      end
    end
  end
end