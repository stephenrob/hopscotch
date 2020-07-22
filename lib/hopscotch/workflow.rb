require 'securerandom'

require 'hopscotch/producer'
require 'hopscotch/publishers/data_message_publisher'

module Hopscotch
  class Workflow
    include Producer, Publishers::DataMessagePublisher

    def self.use_job(klass)
      @jobs ||= []
      @jobs << klass
    end

    def self.jobs
      @jobs
    end

    def jobs
      self.class.jobs
    end

    def run(params: {})
      raise NotImplementedError
    end

    def execute(params: {})
      run(params: params)
      publish_messages
    end

    def queue_message(topic, data)
      queued_messages << {topic: topic, data: data}
    end

    def queued_messages
      @queued_messages ||= []
    end

    def publish_messages
      queued_messages.each do |message|
        publish_data_message(message[:topic], message[:data])
      end
    end

    def id
      @id ||= SecureRandom.uuid
    end

  end
end