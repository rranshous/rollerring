require_relative 'brute_solver'

class StreamSolver < BruteSolver

  def initialize tests, bus, scoreboard
    super tests, bus
    self.scoreboard = scoreboard
  end

  private
  attr_accessor :scoreboard

  def cycle_for_solution
    population_stats.each do |stat|
      update_scoreboard stat
      return stat['individual'] if stat['passes_tests']
    end
    false
  end

  def update_scoreboard stat
    scoreboard.add_score stat['individual'], stat['score']
  end

  def repopulate
    print '.'
    bus.refill high_scores.map(&:individual)
  end

  def high_scores
    scores = scoreboard.scores
    if scores.length != 0
      scores = scores[0..(scores.length * 0.20)]
    end
    scores
  end
end
