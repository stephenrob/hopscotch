require 'securerandom'

module Hopscotch
  class Publisher
    def initialize(connection, exchange)
      @connection = connection
      @exchange = exchange
    end

    def publish(topic, message)
      ensure_connection!

      if message.is_a?(Hopscotch::Message)
        data = message.to_h
        message_id = message.message_id
      elsif message.is_a?(Hash)
        data = message
        message_id = message[:messageId]
      else
        data = message
        message_id = SecureRandom.uuid
      end

      @exchange.publish(Hopscotch.serializer.encode(data), {
          persistent: true,
          message_id: message_id,
          routing_key: topic,
          timestamp: Time.now.to_i,
          content_type: Hopscotch.serializer.content_type
      })
    end

    def ensure_connection!
      raise StandardError.new('not connected') unless @connection
      raise StandardError.new('connection not open') unless @connection.open?
    end
  end
end