require 'pry'
class TestSet

  attr_accessor :tests

  def initialize tests
    self.tests = tests
  end

  def stats_for individual
    { 'individual' => individual,
      'passes_tests' => passes?(individual),
      'score' => score(individual) }
  end

  def passes? individual
    failed_test_count(individual) == 0
  end

  def failed_test_count individual
    tests.reject { |t| t.passes? individual }.length
  end

  def score individual
    tests.map { |t| t.score(individual) }.reduce(&:+)
  end
end
