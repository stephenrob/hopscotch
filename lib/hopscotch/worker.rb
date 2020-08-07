require 'securerandom'
require 'hopscotch/logger'
require 'hopscotch/raw_message'
require 'hopscotch/concerns/custom_broker'

module Hopscotch
  class Worker
    include Logger, CustomBroker

    def self.default_logging_topic
      'hopscotch.system.logger.worker'
    end

    def initialize
      @queue = nil
    end

    def start!
      connect_to_queue! unless @queue
      @subscription = @queue.subscribe(consumer_tag: SecureRandom.uuid, block: false, manual_ack: true) do |delivery_info, properties, body|
        begin

          message = RawMessage.new(delivery_info, properties, body)
          unless message.valid?
            logger.debug("Rejecting message with id #{properties.message_id} due to not being valid")
            broker.reject(message.delivery_info.delivery_tag)
            next
          end
          response = handle_message(message)

          if response == :ack
            broker.ack(message.delivery_info.delivery_tag)
          else
            broker.reject(message.delivery_info.delivery_tag)
          end
          
        rescue StandardError => exception
          Raven.capture_exception(exception)
          broker.reject(message.delivery_info.delivery_tag)
          logger.debug("Rejecting message with id #{properties.message_id} due to error")
        end
      end
    rescue Interrupt => _
      stop!
      exit(0)
    end

    def stop!
      @subscription.cancel if @subscription
      broker.close_channel
    end

    def handle_message(_message)
      raise NotImplementedError
    end

    def connect_to_queue!
      @queue = broker.queue(queue_name)
      @queue.bind(exchange, routing_key: topic)
    end
  end
end