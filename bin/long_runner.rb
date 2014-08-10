require_relative '../solver/ring_engine'
require 'json'

begin
  loop do

    params_raw = $stdin.readline
    puts "params_raw: #{params_raw}"
    params = JSON.parse(params_raw)
    puts "params: #{params}"

    input = params['input']
    program = params['program']
    cycles = params['cycles']

    puts "STARTING"
    r = RingEngine.new(cycles).run(program, input).join(',')
    puts "OUTPUT: #{r}"
    puts "RESULT RING: #{program}"

  end

rescue EOFError
end
