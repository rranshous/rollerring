class TestSet

  attr_accessor :tests

  def initialize tests
    self.tests = tests
  end

  def passes? individual
    failed_test_count(individual) == 0
  end

  def failed_test_count individual
    tests.reject { |t| t.passes? individual }.length
  end
end
