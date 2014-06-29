require_relative 'lib'


ring_size = ARGV.shift.to_i
cycles = ARGV.shift.to_i
population = ARGV.shift.to_i
input_buffer = ARGV.shift.split(',')
search = ARGV.shift.split(',')
Grower.new(search, input_buffer, population, ring_size, cycles).run
