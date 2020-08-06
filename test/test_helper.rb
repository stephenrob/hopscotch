$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter
]

SimpleCov.start

require "hopscotch"

require "minitest/autorun"

require 'mocha/minitest'

require 'faker'