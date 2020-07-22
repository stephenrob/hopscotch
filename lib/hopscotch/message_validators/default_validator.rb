require 'hopscotch/raw_message'
require 'hopscotch/message_validators/message_validator'

module Hopscotch
  module MessageValidators
    class DefaultValidator
      include MessageValidator

      validates_class RawMessage

      validates_meta_present!
      validates_data_present!

      validates_meta_attribute :type
      validates_meta_attribute :version
      validates_meta_attribute :messageId

      validates_data_attribute :deep

      def self.is_valid?(message)
        validators.all? { |validator| validator.call(message) }
      end

    end
  end
end