module Hopscotch
  module Publishers
    module DataMessagePublisher
      def publish_data_message(topic, message)
        Hopscotch.data_publisher.publish(topic, message)
      end
    end
  end
end