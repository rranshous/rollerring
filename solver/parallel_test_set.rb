require_relative 'test_set'
require 'json'

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

class Worker
  def initialize &work
    work
    @input, output = IO.pipe
    input, @output = IO.pipe
    puts "FORKING"
    @proc = fork do
      @input.close
      @output.close
      loop do
        encoded_data = input.readline
        data = JSON.parse(encoded_data)
        result = work.call(data)
        encoded_result = JSON.dump(result)
        output.puts(encoded_result)
      end
    end
    Process.detach @proc
    output.close
    input.close
    puts "DONE FORKING: #{@proc}"
  end

  def push input
    @output.puts(input.to_json)
  end

  def pop
    JSON.parse(@input.readline)
  end
end
