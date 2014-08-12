require 'pry'
class TestSet

  attr_accessor :tests

  def initialize tests
    self.tests = tests
  end

  def stats_for individual
    stats = tests.map { |t| t.stats_for individual }
    { 'individual' => individual,
      'passes_tests' => passes?(stats),
      'score' => score(stats) }
  end

  private

  def passes? stats
    failed_test_count(stats) == 0
  end

  def failed_test_count stats
    stats.reject { |s| s['passes'] }.length
  end

  def score stats
    stats.map { |s| s['score'] }.reduce(&:+)
  end
end
