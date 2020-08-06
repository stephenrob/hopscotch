require 'hopscotch/raw_message'
require 'hopscotch/message_validators/base_validator'

module Hopscotch
  module MessageValidators
    class DefaultValidator < BaseValidator

      validates_class RawMessage

      validates_meta_present!
      validates_data_present!

      validates_meta_attribute :type
      validates_meta_attribute :version
      validates_meta_attribute :messageId

    end
  end
end