module Hopscotch
  module RunnerWorker

    @workers = []

    def initialize
      @stop_flag = ServerEngine::BlockingFlag.new
    end

    def run
      workers = config[:hopscotch_workers]

      @workers = workers.map do |worker|
        if worker.is_a?(Class)
          instance = worker.new
        else
          instance = worker
        end
        instance
      end

      @workers.each do |worker|
        worker.start!
        sleep(2)
      end

      until @stop_flag.wait_for_set(5)
      end
    end

    def stop
      @workers.each do |worker|
        worker.stop!
      end
      Hopscotch.client.close
      @stop_flag.set!
    end

  end
end