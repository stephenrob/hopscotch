module Hopscotch
  module Status
    NEW = 'new'.freeze
    PENDING = 'pending'.freeze
    IN_PROGRESS = 'in_progress'.freeze
    COMPLETE = 'complete'.freeze
    FAILED = 'failed'.freeze
    SKIPPED = 'skipped'.freeze
    RETRY = 'pending_retry'.freeze

    FAILED_STATES = [FAILED].freeze
    COMPLETION_STATES = [FAILED, SKIPPED, COMPLETE].freeze
    ALL_STATES = [NEW, PENDING, IN_PROGRESS, COMPLETE, FAILED, SKIPPED, RETRY].freeze
  end
end