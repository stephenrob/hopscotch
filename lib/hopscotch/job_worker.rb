require 'hopscotch/worker'

module Hopscotch
  class JobWorker < Worker

    def initialize(job_klass, exchange, queue_name)
      @klass = job_klass
      super(exchange, @klass.consumed_message_type, queue_name)
    end

    def handle_message(message)
      response = @klass.new.handle(message)
      if response == :ack
        Hopscotch.broker.ack(message.delivery_info.delivery_tag)
      else
        Hopscotch.broker.reject(message.delivery_info.delivery_tag)
      end
    end

  end
end