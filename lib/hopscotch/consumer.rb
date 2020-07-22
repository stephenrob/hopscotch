module Hopscotch
  module Consumer

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def consumes(message)
        @consumed_message_type = message
      end

      def consumed_message_type
        @consumed_message_type ||= nil
      end
    end

  end
end