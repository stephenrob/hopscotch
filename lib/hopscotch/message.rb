require 'securerandom'

module Hopscotch
  class Message
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

      if @meta.is_a?(Hash) && (!@meta.nil? && !@meta.empty?)
        meta_details.merge!(@meta)
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