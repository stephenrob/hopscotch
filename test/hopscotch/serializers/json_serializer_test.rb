require 'test_helper'

module Hopscotch
  module Serializers
    class JsonSerializerTest < Minitest::Test
      def setup
        @serializer = JsonSerializer
      end

      def teardown
        # Do nothing
      end

      def test_content_type_should_set
        assert_equal 'application/json', @serializer.content_type
      end

      def test_returns_message_encoded_as_json_string
        message = {
            hello: 'world'
        }

        assert_equal '{"hello":"world"}', @serializer.encode(message)
      end

      def test_returns_json_string_as_decoded_hash
        message = '{"hello":"world"}'

        expected_message = {
            hello: 'world'
        }

        assert_equal expected_message, @serializer.decode(message)
      end

    end
  end
end