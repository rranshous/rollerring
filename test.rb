require_relative 'lib'

tests = [
  ['output','','1','output|1|end'],
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
   'place|input|-9|-9|-9|output|fork|3|end|1'],
  ['gt','','0,0,0,2','gt|1|output|-1|0|1|2|end'],
  ['lt','','-1,0,0,0','lt|1|output|-1|0|1|2|end'],
  ['toinput','1','1,1,1','output|input|toinput|0|0|0|end'],
  ['condend','','1,0','condend|output|1|0|1|end'],
  ['condend_value','','1,0','condend|output|add|1|-1|0|1|end'],
  ['loop','','1,1,1,1',
   'step|1|output|1|output|place|add|-1|condend|4|condend|place|add|0|step|-15|-999']
]

tests.each do |(name, input, output, ring)|
  puts
  puts "STARTING: #{name}"
  output = output.split(',')
  original_output = output.dup
  input = input.split(',')
  original_input = input.dup
  ring = ring.split('|')
  original_ring = ring.dup
  test_output = Ring.new(ring).run(0, 100, input)
  if test_output != output
    raise "Failed [#{name}]| #{original_output} != #{test_output} :: [#{original_input}] #{original_ring}"
  end
  puts "ENDING: #{name} :: #{input}"
end
