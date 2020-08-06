require 'test_helper'

module Hopscotch
  module MessageValidators
    class BaseValidatorTest < Minitest::Test
      def setup
        @validator = BaseValidator
      end

      def test_is_valid_returns_true_when_all_validators_return_true
        assert @validator.is_valid?({})
      end
    end
  end
end