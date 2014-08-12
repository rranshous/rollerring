class SimpleTest

  def initialize ring_engine, input, expected_output, scorer
    self.input = input
    self.expected_output = expected_output
    self.ring_engine = ring_engine
    self.scorer = scorer
  end

  def stats_for individual
    output = run individual
    { 'passes' => passes?(output),
      'score' => score(output) }
  end

  private

  attr_accessor :input, :expected_output, :ring_engine, :scorer

  def passes? output
    expected_output == output
  end

  def score output
    scorer.score(expected_output, output)
  end

  def run individual
    ring_engine.run(individual, input)
  end

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
