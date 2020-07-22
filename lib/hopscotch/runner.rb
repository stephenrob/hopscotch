require 'serverengine'
require 'hopscotch/runner_worker'

module Hopscotch
  class Runner
    def initialize(workers=[])
      @workers = workers
    end

    def run
      engine.run
    end

    def stop
      engine.stop(true)
    end

    def engine
      @engine ||= create_engine!
    end

    def create_engine!
      ServerEngine.create(nil, RunnerWorker, {
          daemonize: false,
          log: '-',
          workers: @workers
      })
    end
  end
end