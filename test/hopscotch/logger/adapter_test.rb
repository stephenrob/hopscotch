require 'test_helper'

module Hopscotch
  module Logger
    class AdapterTest < Minitest::Test
      def setup
        @formatter = MessageFormatter.new
        @adapter = Adapter.new(level: :debug, formatter: @formatter)
        @log = SemanticLogger::Log.new("TestLogger", :debug)
      end

      def teardown
        # Do nothing
      end

      def test_it_publishes_message_to_the_default_logs_topic

        @formatter.expects(:call).returns(formatted_message)

        system_publisher = mock
        system_publisher.expects(:publish).with('hopscotch.logger', formatted_message).once

        Hopscotch.expects(:system_publisher).returns(system_publisher)

        @log.assign(message: "HelloWorld", payload: { hello: "world" })

        @adapter.log(@log)

      end

      def test_it_publishes_message_to_the_custom_logs_topic

        adapter = Adapter.new(message_topic: 'custom.topic', level: :debug, formatter: @formatter)
        log = SemanticLogger::Log.new("TestLogger", :debug)

        @formatter.expects(:call).returns(formatted_message)

        system_publisher = mock
        system_publisher.expects(:publish).with('custom.topic', formatted_message).once

        Hopscotch.expects(:system_publisher).returns(system_publisher)

        log.assign(message: "HelloWorld", payload: { hello: "world" })

        adapter.log(@log)

      end

      def formatted_message
        {
            :meta => {
                :messageId => "0c8f7022-a47e-464d-8bd4-54ce19e13d8f",
                :version => "0.1.0",
                :type => "hopscotch.logger.message"
            },
            :data => {
                :logEvent => {
                    :time => "2020-08-06 15:27:50.874105",
                    :level => :debug,
                    :level_index => 1,
                    :name => "TestLogger",
                    :message => "HelloWorld",
                    :payload => {
                        :hello => "world"
                    }
                }
            }
        }
      end

    end
  end
end