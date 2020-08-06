require 'test_helper'

module Hopscotch
  class LoggerTest < Minitest::Test
    def setup
      @logger_class = TestLoggerClass
      @logger_instance = TestLoggerClass.new
    end

    def teardown
      @logger_class.instance_variable_set(:@logging_topic, nil)
      @logger_instance.instance_variable_set(:@logger, nil)
    end

    def test_default_logger_topic_is_set
      assert_equal 'hopscotch.system.logger', @logger_class.default_logging_topic
    end

    def test_logging_topic_is_set_to_default_when_none_is_set

      refute @logger_class.instance_variable_get(:@logging_topic)

      assert_equal 'hopscotch.system.logger', @logger_class.logging_topic

    end

    def test_logging_topic_returns_custom_logging_topic_when_set

      refute @logger_class.instance_variable_get(:@logging_topic)

      @logger_class.use_logging_topic('custom.logger.topic')

      assert_equal 'custom.logger.topic', @logger_class.logging_topic

    end

    def test_logger_returns_instance_of_log_adapter_if_not_set

      refute @logger_instance.instance_variable_get(:@logger)

      assert_instance_of Logger::Adapter, @logger_instance.logger

    end

    def test_logger_returns_new_instance_of_log_adapter_if_not_set

      refute @logger_instance.instance_variable_get(:@logger)

      Logger::Adapter.expects(:new).once.returns(mock)

      assert @logger_instance.logger

    end

    def test_logger_returns_set_instance_if_logger_is_set

      refute @logger_instance.instance_variable_get(:@logger)

      @logger_instance.instance_variable_set(:@logger, mock)

      assert @logger_instance.instance_variable_get(:@logger)

      Logger::Adapter.expects(:new).never

      assert @logger_instance.logger

    end

    class TestLoggerClass
      include Logger
    end

  end
end