require_relative '../lib'
require 'pry'

# given an enumerable set of tests
# the solver will grow individuals until
# it has a set which will pass all the tests

require_relative 'random_bus'
require_relative 'birther'
require_relative 'brute_solver'
require_relative 'simple_test'
require_relative 'test_set'
require_relative 'ring_engine'

require_relative 'scoreboard'
require_relative 'stream_solver'
require_relative 'genetic_bus'
require_relative 'mater'
require_relative 'mutator'
require_relative 'scorer'
