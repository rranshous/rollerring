require_relative 'test_set'
require_relative '../lib/worker'

class ParallelTestSet < TestSet
  def initialize tests
    super
    @workers = start_workers
  end

  def failed_test_count? individual
    @workers.each do |worker|
      worker.push type: 'passes',
                  individual: individual
    end
    .map do |worker|
      worker.pop
    end
    .reject do |result|
      result['result']
    end
    .length
  end

  def score individual
    @workers.each do |worker|
      worker.push type: 'score',
                  individual: individual
    end
    .map do |worker|
      worker.pop
    end
    .reduce(0) do |agg, result|
      agg + result['result']
    end
  end

  private

  def start_workers
    tests.map do |test|
      Worker.new do |opts|
        { result: handle_work(test, opts) }
      end
    end
  end

  def handle_work test, opts
    individual = opts['individual']
    case opts['type']
    when 'passes'
      test.passes? individual
    when 'score'
      test.score individual
    end
  end
end
