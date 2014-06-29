require_relative 'lib'

tests = [
  ['simple','','1,2,3','output|1|2|3|end'],
  ['noop', '','1,2,3','output|1|noop|2|3|end'],
  ['step_simple','','1,2,3','step|2|9|output|8|1|7|2|6|3|5|end'],
  ['fork_simple','','1,2,3','step|2|10|fork|9|1|output|1|2|3|end|7|6|end'],
  ['add_simple','','1,2,3','add|1|output|0|1|2|end'],
  ['subtract_simple','','9','subtract|1|output|10|end'],
  ['multiply_simple','','5','multiply|5|output|1|end'],
  ['divide_simple','','2','divide|2|output|4|end'],
  ['place_simple','','2','place|add|1|1|9|fork|1|end|output'],
  ['input_simple','1,2,3','1,2,3','output|input|-9|-9|-9|end'],
  ['input_place','1,2,3,3','3,0,0,0,0,0,1,2,3',
   'place|input|-9|-9|-9|output|fork|3|end|1']
]

tests.each do |(name, input, output, ring)|
  puts
  puts "STARTING: #{name}"
  output = output.split(',')
  input = input.split(',')
  ring = ring.split('|')
  test_output = Ring.new(ring).run(0, 25, input)
  if test_output != output
    raise "Failed [#{name}]| #{output} != #{test_output}"
  end
  puts "ENDING: #{name}"
end
