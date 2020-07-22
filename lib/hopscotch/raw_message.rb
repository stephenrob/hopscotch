require 'hopscotch/message'

module Hopscotch
  class RawMessage

    attr_reader :delivery_info, :properties, :payload, :body

    def initialize(delivery_info, properties, payload, serializer: Hopscotch.serializer)
      @delivery_info = delivery_info
      @properties = properties
      @payload = payload
      @body = serializer.decode(payload)
    end

    def valid?
      return false unless body.keys.include? :meta
      return false unless body.keys.include? :data
      return false unless [:type, :version, :messageId].all? { |key| body[:meta].keys.include? key }

      true
    end

    def processed_message
      @processed_message ||= process_message!
    end

    def process_message!
      message_type = body[:meta][:type]
      message_version = body[:meta][:version]
      message_id = body[:meta][:messageId]
      message_meta = body[:meta]
      message_data = body[:data]
      Message.new(message_type, message_version, message_id: message_id, meta: message_meta, data: message_data)
    end

  end
end