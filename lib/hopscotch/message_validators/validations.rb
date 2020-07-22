module Hopscotch
  module MessageValidators
    module Validations

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def validators
          @validators ||= []
        end

        def validates_class(klass)
          validation_func = -> (message) { message.is_a?(klass) }
          validators << validation_func
        end

        def validates_meta_attribute(attribute)
          validation_func = -> (message) {

            if message.body[:meta].nil?
              return false
            end

            return false unless message.body[:meta].respond_to?(:keys)

            message.body[:meta].keys.include? attribute

          }
          validators << validation_func
        end

        def validates_data_attribute(attribute)
          validation_func = -> (message) {

            if message.body[:data].nil?
              return false
            end

            return false unless message.body[:data].respond_to?(:keys)

            message.body[:data].keys.include? attribute

          }
          validators << validation_func
        end

        def validates_attribute(attribute)
          validation_func = -> (message) {

            if message.body.nil?
              return false
            end

            return false unless message.body.respond_to?(:keys)

            message.body.keys.include? attribute

          }
          validators << validation_func
        end

        def validates_meta_present!
          validates_attribute :meta
        end

        def validates_data_present!
          validates_attribute :data
        end

      end

    end
  end
end