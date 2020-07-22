module Hopscotch
  module Publishers
    module SystemMessagePublisher
      def publish_system_message(topic, message)
        Hopscotch.system_publisher.publish(topic, message)
      end
    end
  end
end