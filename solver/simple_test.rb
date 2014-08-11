class SimpleTest
  def initialize ring_engine, input, expected_output, scorer
    self.input = input
    self.expected_output = expected_output
    self.ring_engine = ring_engine
    self.scorer = scorer
  end

  def passes? individual
    return false unless can_output?(individual) || expected_output.length == 0
    expected_output == ring_engine.run(individual, input)
  end

  def score individual
    output = ring_engine.run(individual, input)
    scorer.score(expected_output, output)
  end

  private

  attr_accessor :input, :expected_output, :ring_engine, :scorer

  def can_output? individual
    individual.include?('output')
  end

end

class IntrospectionTest < SimpleTest
  def initialize *args
  end
  def passes? individual
    raise NotImplimentedError
  end
  def score individual
    return passes?(individual) ? 0 : 1
  end
end

class OutputTest < IntrospectionTest
  def passes? individual
    individual.include?('output')
  end
end

class InputTest < IntrospectionTest
  def passes? individual
    individual.include?('input')
  end
end

class EndTest < IntrospectionTest
  def passes? individual
    individual.include?('end')
  end
end

class PlaceTest < IntrospectionTest
  def passes? individual
    individual.include?('place')
  end
end

class ImmediateEndTest < IntrospectionTest
  def passes? individual
    individual.first != 'end'
  end
end
