require 'securerandom'

require 'hopscotch/producer'
require 'hopscotch/publishers/data_message_publisher'
require 'hopscotch/workflow_message'

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

    def queue_message(topic, message)
      queued_messages << {topic: topic, message: message}
    end

    alias_method :publish_message, :queue_message

    def queued_messages
      @queued_messages ||= []
    end

    def publish_messages
      queued_messages.each do |message|
        publish_data_message(message[:topic], WorkflowMessage.from_message(message[:message], self.class.to_s, workflow_id: id))
      end
    end

    def id
      @id ||= SecureRandom.uuid
    end

  end
end