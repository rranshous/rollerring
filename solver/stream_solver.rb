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
    print '.'
    bus.refill high_scores.map(&:individual)
  end

  def high_scores
    scores = scoreboard.scores
    if scores.length != 0
      best = scores.first.score
      scores = scores.select{ |s| s.score <= best }
    end
    scores
  end

end
