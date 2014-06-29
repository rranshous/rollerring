require_relative 'solver'
require 'benchmark'

type = ARGV.shift
POPULATION_SIZE = [ARGV.shift.to_i, 10].max
RING_SIZE = [ARGV.shift.to_i, 10].max
CYCLE_MULTIPLIER = [ARGV.shift.to_i, 1].max
ring_engine = RingEngine.new(RING_SIZE * CYCLE_MULTIPLIER)

tests = ARGV.map do |arg|
  input, expected = arg.split(':')
  input = input.split(',')
  expected = expected.split(',')
  puts "input/expected: #{input}/#{expected}"
  SimpleTest.new(ring_engine, input, expected)
end
test_set = TestSet.new tests
birther = Birther.new(RING_SIZE)

puts "popualtion: #{POPULATION_SIZE}"
puts "ring size: #{RING_SIZE}"
puts "cycle multiplier #{CYCLE_MULTIPLIER}"

if type == 'brute'
  bus = RandomBus.new(birther, POPULATION_SIZE)
  solver = BruteSolver.new test_set, bus
elsif type.start_with?('genetic')
  mater = Mater
  mutator = Mutator
  scoreboard = Scoreboard.new POPULATION_SIZE/2
  bus = GeneticBus.new(birther, mater, mutator, POPULATION_SIZE)
  solver = StreamSolver.new(test_set, bus, scoreboard)
else
  puts "type not defined"
end

if type == 'geneticbm'
  puts "BENCHMARKING"
  solutions = []
  n = 10
  Benchmark.bm do |x|
    n.times do
      scoreboard = Scoreboard.new POPULATION_SIZE/2
      bus = GeneticBus.new(birther, mater, mutator, POPULATION_SIZE)
      solver = StreamSolver.new(test_set, bus, scoreboard)
      x.report { solutions << solver.find_solution.join('|') }
    end
    puts
    puts "SOLUTIONS: #{solutions.join("\n")}"
  end
else
  puts "SOLUTION: #{solver.find_solution{puts('.')}.join('|')}"
end
