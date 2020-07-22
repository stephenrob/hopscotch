require 'hopscotch/consumer'

module Hopscotch
  module Handlers
    class CreateWorkflow
      include Consumer

      consumes 'hopscotch.system.workflow.create'

      def handle(message)
        workflow_klass = message["workflow"]["name"]
        params = message["workflow"]["params"]

        Kernel.const_get(workflow_klass).new.execute(params: params)
      end

    end
  end
end