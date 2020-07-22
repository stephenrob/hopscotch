require 'bunny'
require 'dry-configurable'

require "hopscotch/version"
require 'hopscotch/job'
require 'hopscotch/workflow'
require 'hopscotch/broker'
require 'hopscotch/publisher'
require 'hopscotch/message'
require 'hopscotch/serializers/json_serializer'
require 'hopscotch/status'
require 'hopscotch/logger'

module Hopscotch
  extend Dry::Configurable

  class Error < StandardError; end

  setting :client, Bunny.new, reader: true
  setting :serializer, Hopscotch::Serializers::JsonSerializer, reader: true
  setting :log_adapter, Hopscotch::Logger::Adapter, reader: true
  setting :log_formatter, Hopscotch::Logger::MessageFormatter, reader: true

  def self.broker
    @broker ||= Hopscotch::Broker.new(client)
  end

  def self.data_publisher
    @data_publisher ||= Hopscotch::Publisher.new(broker.connection, broker.data_exchange)
  end

  def self.system_publisher
    @system_publisher ||= Hopscotch::Publisher.new(broker.connection, broker.system_exchange)
  end
end
