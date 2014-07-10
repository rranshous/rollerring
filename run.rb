require_relative 'solver/ring_engine'
require 'pry'

input = ARGV.shift.split(',')
program = ARGV.shift.split('|')
cycles = [ARGV.shift.to_i, 100].max


puts "STARTING"
r = RingEngine.new(cycles).run(program, input).join(',')
puts "OUTPUT: #{r}"
puts "RESULT RING: #{program}"
