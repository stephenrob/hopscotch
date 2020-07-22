require 'semantic_logger'

module Hopscotch
  module Logger
    class Adapter < ::SemanticLogger::Subscriber

      def initialize(message_topic: 'hopscotch.logger', level: nil, formatter: nil, filter: nil, application: nil, environment: nil, host: nil, metrics: nil, &block)
        @message_topic = message_topic
        super(level: level, formatter: formatter, filter: filter, application: application, environment: environment, host: host, metrics: metrics, &block)
      end

      def log(log)
        log_message = formatter.call(log, self)
        Hopscotch.system_publisher.publish(@message_topic, log_message)
      end

    end
  end
end