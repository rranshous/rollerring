class SimpleTest
  def initialize ring_engine, input, expected_output
    self.input = input
    self.expected_output = expected_output
    self.ring_engine = ring_engine
  end

  def passes? individual
    return false unless expected_output.length == 0 or can_output?(individual)
    expected_output == ring_engine.run(individual, input)
  end

  private

  attr_accessor :input, :expected_output, :ring_engine

  def can_output? individual
    individual.include?('output')
  end

end

class OutputTest
  def passes? individual
    individual.include?('output')
  end
end

class InputTest
  def passes? individual
    individual.include?('input')
  end
end

class EndTest
  def passes? individual
    individual.include?('end')
  end
end

class PlaceTest
  def passes? individual
    individual.include?('place')
  end
end


class ImmediateEndTest
  def passes? individual
    individual.first != 'end'
  end
end
