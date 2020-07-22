require 'securerandom'
require 'hopscotch/logger'
require 'hopscotch/raw_message'

module Hopscotch
  class Worker
    include Logger

    def self.default_logging_topic
      'hopscotch.system.logger.worker'
    end

    def initialize(exchange, topic, queue_name)
      @exchange = exchange
      @topic = topic
      @queue_name = queue_name
      @queue = nil
    end

    def start!
      connect_to_queue! unless @queue
      @queue.subscribe(consumer_tag: SecureRandom.uuid, block: true, manual_ack: true) do |delivery_info, properties, body|
        message = RawMessage.new(delivery_info, properties, body)
        unless message.valid?
          logger.debug("Rejecting message with id #{properties.message_id} due to not being valid")
          Hopscotch.broker.reject(message.delivery_info.delivery_tag)
          next
        end
        handle_message(message)
      end
    rescue Interrupt => _
      Hopscotch.broker.close
      exit(0)
    end

    def handle_message(_message)
      raise NotImplementedError
    end

    def connect_to_queue!
      @queue = Hopscotch.broker.queue(@queue_name)
      @queue.bind(@exchange, routing_key: @topic)
    end
  end
end