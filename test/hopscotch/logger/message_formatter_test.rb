require 'test_helper'

module Hopscotch
  module Logger
    class MessageFormatterTest < Minitest::Test
      def setup
        @formatter = MessageFormatter.new
        @adapter = Adapter.new(level: :debug, formatter: @formatter)
        @log = SemanticLogger::Log.new("TestLogger", :debug)
      end

      def teardown
        # Do nothing
      end

      def test_it_returns_hash_with_meta_and_data_objects

        @log.assign(message: "HelloWorld", payload: { hello: "world" })

        response = @formatter.call(@log, @adapter)

        assert_includes response.keys, :meta
        assert_includes response.keys, :data

      end

      def test_it_generates_message_id_for_message
        SecureRandom.expects(:uuid).returns("uuid-1234-5678")

        response = @formatter.call(@log, @adapter)

        assert_includes response.keys, :meta
        assert_includes response[:meta].keys, :messageId
        assert_equal "uuid-1234-5678", response[:meta][:messageId]
      end

      def test_it_sets_default_version_and_type_in_meta_for_message
        response = @formatter.call(@log, @adapter)

        assert_includes response.keys, :meta
        assert_includes response[:meta].keys, :version
        assert_includes response[:meta].keys, :type

        assert_equal "0.1.0", response[:meta][:version]
        assert_equal "hopscotch.logger.message", response[:meta][:type]
      end

      def test_it_sets_custom_version_and_type_in_meta_for_message
        formatter = MessageFormatter.new(message_version: '1.1.0', message_type: 'test.custom.type')
        adapter = Adapter.new(formatter: @formatter)
        log = SemanticLogger::Log.new("TestLogger", :debug)

        response = formatter.call(log, adapter)

        assert_includes response.keys, :meta
        assert_includes response[:meta].keys, :version
        assert_includes response[:meta].keys, :type

        assert_equal "1.1.0", response[:meta][:version]
        assert_equal "test.custom.type", response[:meta][:type]
      end

      def test_message_data_should_include_log_event_with_all_fields
        @log.assign(message: "HelloWorld", payload: { taskRunId: "run-54321" })

        response = @formatter.call(@log, @adapter)

        assert_includes response.keys, :data
        assert_includes response[:data].keys, :logEvent

        log_event = response[:data][:logEvent]

        assert_equal "HelloWorld", log_event[:message]
        assert_equal "run-54321", log_event[:payload][:taskRunId]
      end

    end
  end
end