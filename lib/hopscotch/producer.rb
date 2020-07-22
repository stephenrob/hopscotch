module Hopscotch
  module Producer

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def produces(*types)
        @published_message_types = self.published_message_types.union(types)
      end

      def published_message_types
        @published_message_types ||= Set.new
      end
    end
  end
end