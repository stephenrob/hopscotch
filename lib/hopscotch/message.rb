require 'securerandom'

module Hopscotch
  class Message

    attr_reader :message_type, :message_version, :data

    def initialize(message_type, message_version, message_id: nil, data: {}, meta: {})
      @message_type = message_type
      @message_version = message_version
      @message_id = message_id
      @data = data
      @custom_meta = meta
    end

    def meta
      meta_details = {
          messageId: message_id,
          type: @message_type,
          version: @message_version
      }

      if @custom_meta.is_a?(Hash) && (!@custom_meta.nil? && !@custom_meta.empty?)
        meta_details.merge!(@custom_meta)
      end

      meta_details
    end

    def to_h
      {
          meta: meta,
          data: @data
      }
    end

    def message_id
      @message_id ||= SecureRandom.uuid
    end

  end
end