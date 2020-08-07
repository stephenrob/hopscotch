module Hopscotch
  class Broker
    attr_reader :connection, :channel

    def initialize(connection)
      @connection = connection
      @channel = nil
      @data_exchange = nil
      @system_exchange = nil
    end

    def data_exchange
      @data_exchange ||= connect_to_exchange!(Hopscotch.data_exchange_name)
    end

    def system_exchange
      @system_exchange ||= connect_to_exchange!(Hopscotch.system_exchange_name)
    end

    def connect_to_exchange!(name)
      start_connection!
      create_channel! unless channel
      create_exchange!(name)
    end

    def queue(name, prefetch: 5, durable: true)
      start_connection!
      create_channel! unless channel
      @channel.prefetch(prefetch)
      @channel.queue(name, {durable: durable})
    end

    def create_exchange!(name, type: 'topic')
      require_connection!
      require_channel!
      Bunny::Exchange.new(@channel, type, name, {durable: true})
    end

    def start_connection!
      @connection.start
    end

    def create_channel!
      @channel = @connection.create_channel
    end

    def close_channel
      channel.close if channel
      @channel = nil
    end

    def close
      close_channel
      @connection.close if @connection
    end

    def ack(delivery_tag)
      require_connection!
      require_channel!
      channel.ack(delivery_tag, false)
    end

    def reject(delivery_tag, requeue=false)
      require_connection!
      require_channel!
      channel.reject(delivery_tag, requeue)
    end

    def require_connection!
      raise StandardError.new('No connection') unless connection
    end

    def require_channel!
      raise StandardError.new('No channel') unless channel
    end

  end
end