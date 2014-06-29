require_relative 'brute_solver'

class StreamSolver < BruteSolver

  def initialize tests, bus, scoreboard
    super tests, bus
    self.scoreboard = scoreboard
  end

  private
  attr_accessor :scoreboard

  def passes_tests? individual
    original_individual = individual.dup
    failed_tests = test_set.failed_test_count individual
    scoreboard.add_score original_individual, failed_tests
    failed_tests == 0
  end

  def repopulate
    bus.refill scoreboard.scores.map(&:individual)
  end

end
