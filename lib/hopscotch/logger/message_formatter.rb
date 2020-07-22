require 'semantic_logger'
require 'securerandom'

module Hopscotch
  module Logger
    class MessageFormatter < ::SemanticLogger::Formatters::Raw

      def initialize(message_type: 'hopscotch.logger.message', message_version: '0.1.0', time_format: nil, time_key: nil, **args)
        @message_type = message_type
        @message_version = message_version
        super(time_format: time_format, time_key: time_key, **args)
      end

      def call(log, logger)
        self.hash = {}
        self.log = log
        self.logger = logger

        environment
        time
        level
        file_name_and_line
        duration
        tags
        named_tags
        name
        message
        payload
        metric

        {
            meta: generate_message_meta,
            data: {
                logEvent: hash,
            },
        }
      end

      private

      def generate_message_meta
        {
            messageId: SecureRandom.uuid,
            version: @message_version,
            type: @message_type
        }
      end

    end
  end
end