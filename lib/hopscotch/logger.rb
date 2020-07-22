require 'hopscotch/logger/adapter'
require 'hopscotch/logger/message_formatter'

module Hopscotch
  module Logger

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def use_logging_topic(logging_topic)
        @logging_topic = logging_topic
      end

      def logging_topic
        @logging_topic ||= default_logging_topic
      end

      def default_logging_topic
        'hopscotch.system.logger'
      end
    end

    def logger
      @logger ||= Hopscotch.log_adapter.new(message_topic: self.class.logging_topic, formatter: Hopscotch.log_formatter.new, level: :debug)
    end

  end
end