require 'test_helper'

module Hopscotch
  module MessageValidators
    class ValidationsTest < Minitest::Test
      def setup
        @validations = ValidationsTestClass
      end

      def teardown
        @validations.instance_variable_set(:@validators, [])
      end

      def test_validators_should_be_an_empty_array
        assert_equal [], @validations.validators
      end

      def test_validates_class_returns_true_if_message_matches_class

        @validations.validates_class String
        
        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        assert proc.call("SomeString")

      end

      def test_validates_class_returns_false_if_message_matches_class

        @validations.validates_class String

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        refute proc.call(Array.new)

      end

      def test_validates_meta_attribute_returns_true_if_meta_object_contains_attribute

        @validations.validates_meta_attribute :test_attribute

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         meta: {
                                                             test_attribute: 'hello',
                                                             hello: 'world'
                                                         }
                                                     })

        assert proc.call(message)

      end

      def test_validates_meta_attribute_returns_false_if_meta_object_does_not_contain_attribute

        @validations.validates_meta_attribute :test_attribute

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         meta: {
                                                             hello: 'world'
                                                         }
                                                     })

        refute proc.call(message)

      end

      def test_validates_meta_attribute_returns_false_if_meta_object_does_not_exist

        @validations.validates_meta_attribute :test_attribute

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         something: {
                                                             hello: 'world'
                                                         }
                                                     })

        refute proc.call(message)

      end

      def test_validates_data_attribute_returns_true_if_data_object_contains_attribute

        @validations.validates_data_attribute :test_attribute

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         data: {
                                                             test_attribute: 'hello',
                                                             hello: 'world'
                                                         }
                                                     })

        assert proc.call(message)

      end

      def test_validates_data_attribute_returns_false_if_data_object_does_not_contain_attribute

        @validations.validates_data_attribute :test_attribute

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         data: {
                                                             hello: 'world'
                                                         }
                                                     })

        refute proc.call(message)

      end

      def test_validates_data_attribute_returns_false_if_data_object_does_not_exist

        @validations.validates_data_attribute :test_attribute

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         something: {
                                                             hello: 'world'
                                                         }
                                                     })

        refute proc.call(message)

      end

      def test_validates_attribute_returns_true_if_body_contains_attribute

        @validations.validates_attribute :data

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         data: {
                                                             test_attribute: 'hello',
                                                             hello: 'world'
                                                         }
                                                     })

        assert proc.call(message)

      end

      def test_validates_attribute_returns_false_if_body_does_not_contain_attribute

        @validations.validates_attribute :something

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns({
                                                         data: {
                                                             hello: 'world'
                                                         }
                                                     })

        refute proc.call(message)

      end

      def test_validates_attribute_returns_false_if_body_does_not_exist

        @validations.validates_attribute :data

        assert_equal 1, @validations.validators.length
        assert_instance_of Proc, @validations.validators.first

        proc = @validations.validators.first

        message = mock

        message.expects(:body).at_least_once.returns(nil)

        refute proc.call(message)

      end

    end

    class ValidationsTestClass

      include Validations

    end

  end
end