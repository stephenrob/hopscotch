require 'hopscotch/worker'

module Hopscotch
  class JobWorker < Worker

    def initialize(job_klass, exchange, queue_name)
      @klass = job_klass
      @topic = @klass.consumed_message_type
      @queue_name = queue_name
      @exchange = exchange
    end

    def handle_message(message)
      @klass.new.handle(message)
    end

  end
end