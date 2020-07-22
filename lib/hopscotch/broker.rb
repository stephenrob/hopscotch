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
      @data_exchange ||= connect_to_exchange!('hopscotch.data')
    end

    def system_exchange
      @system_exchange ||= connect_to_exchange!('hopscotch.system')
    end

    def connect_to_exchange!(name)
      start_connection!
      create_channel! unless channel
      create_exchange!(name)
    end

    def queue(name)
      start_connection!
      create_channel! unless channel
      @channel.prefetch(1)
      @channel.queue(name, {durable: true})
    end

    def create_exchange!(name, type: 'topic')
      Bunny::Exchange.new(@channel, type, name, {durable: true})
    end

    def start_connection!
      @connection.start
    end

    def create_channel!
      @channel = @connection.create_channel
    end

    def close
      channel.close if channel
      @connection.close if @connection
      @channel = nil
    end

    def ack(delivery_tag)
      start_connection!
      create_channel! unless channel
      channel.ack(delivery_tag, false)
    end

    def reject(delivery_tag, requeue=false)
      start_connection!
      create_channel! unless channel
      channel.reject(delivery_tag, requeue)
    end

  end
end