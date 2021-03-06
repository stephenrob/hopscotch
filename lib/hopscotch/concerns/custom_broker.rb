module Hopscotch
  module CustomBroker

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def use_exchange(exchange)
        @exchange_name = exchange
      end

      def listen_on_topic(topic)
        @topic = topic
      end

      def use_queue(queue)
        @queue_name = queue
      end

      def queue_name
        @queue_name
      end

      def topic
        @topic
      end

      def exchange
        @exchange_name
      end

    end

    def exchange
      @exchange_name ||= self.class.exchange
      @exchange ||= @broker.connect_to_exchange!(@exchange_name)
    end

    def queue_name
      @queue_name ||= self.class.queue_name
    end

    def topic
      @topic ||= self.class.topic
    end

    def broker
      @broker ||= Hopscotch::Broker.new(Hopscotch.client)
    end

  end
end