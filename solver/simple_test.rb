class SimpleTest
  def initialize ring_engine, input, expected_output
    self.input = input
    self.expected_output = expected_output
    self.ring_engine = ring_engine
  end

  def passes? individual
    expected_output == ring_engine.run(individual, input)
  end

  private
  attr_accessor :input, :expected_output, :ring_engine
end
