require_relative 'solver'
require 'benchmark'

type = ARGV.shift
POPULATION_SIZE = [ARGV.shift.to_i, 2].max
RING_SIZE = [ARGV.shift.to_i, 3].max
CYCLE_MULTIPLIER = [ARGV.shift.to_i, 1].max
FIRST_TESTS = 1000

scorer = Scorer
ring_engine = CachingRingEngine.new(RING_SIZE * CYCLE_MULTIPLIER)
tests = ARGV.map do |arg|
  input, expected = arg.split(':')
  input = input.split(',')
  expected = expected.split(',')
  [input, expected]
end.sort_by do |(input, expected)|
  expected.length
end.take(FIRST_TESTS).map do |(input, expected)|
  puts "input/expected: #{input}/#{expected}"
  SimpleTest.new(ring_engine, input, expected, scorer)
end# + [OutputTest.new, InputTest.new, # PlaceTest.new,
   #    ImmediateEndTest.new]


test_set = TestSet.new tests
birther = Birther.new(RING_SIZE)

puts "popualtion: #{POPULATION_SIZE}"
puts "ring size: #{RING_SIZE}"
puts "cycle multiplier #{CYCLE_MULTIPLIER}"
puts "tests: #{tests.length}"

if type == 'brute'
  puts "BRUTE"
  bus = RandomBus.new(birther, POPULATION_SIZE)
  solver = BruteSolver.new(test_set, bus)
elsif type.start_with?('genetic')
  mater = Mater
  mutator = Mutator
  scoreboard = Scoreboard.new POPULATION_SIZE/2
  bus = GeneticBus.new(birther, mater, mutator, POPULATION_SIZE)
  solver = StreamSolver.include(ParallelSolver).new(test_set, bus, scoreboard)
else
  puts "type not defined"
end

if type == 'geneticbm'
  puts "BENCHMARKING"
  solutions = []
  n = 5
  Benchmark.bm do |x|
    n.times do
      scoreboard = Scoreboard.new POPULATION_SIZE/2
      bus = GeneticBus.new(birther, mater, mutator, POPULATION_SIZE)
      solver = StreamSolver.new(test_set, bus, scoreboard)
      x.report { solutions << solver.find_solution.join('|') }
      puts "SOLUTION: #{solutions.last}"
    end
  end
else
  puts "SOLUTION: #{solver.find_solution.join('|')}"
end
