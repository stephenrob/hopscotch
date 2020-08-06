require 'hopscotch/message_validators/validations'

module Hopscotch
  module MessageValidators
    class BaseValidator
      include Validations

      def self.is_valid?(message)
        validators.all? { |validator| validator.call(message) }
      end
    end
  end
end