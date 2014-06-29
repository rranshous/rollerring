require 'thread'

## game of freeze, input buffer has state of whether
# you are being looked at inserted into input buffer
# at begining of cycle. output buffer is read at end of cycle
# any non zero output is freeze

class Brain
  def initialize input, output, ring
    @input = input
    @output = output
    @input_buffer = []
    @output_buffer = []
    @ring_size = ring_size
    @ring = ring
    @cycle_count = 0
  end

  def build
    @nodes << new_node
  end

  def cycle
    buffer_input
    cycle_ring
    send_output
  end

  private

  def cycle_ring
    @ring.cycle(@cycle_count, @input_buffer, nil, @output_buffer)
    @cycle_count += 1
  end

  def buffer_input
    while(input=@input.shift) do
      @input_buffer << input
    end
  end

  def send_output
    while(output=@output_buffer.shift) do
      @output << output
    end
  end

  def new_node
    Ring.new(0, node_cycles, @input_buffer, nil, @output_buffer)
  end

end

input = Queue.new
output = Queue.new
ring_size = 20
ring = Ring.new(RingGen.random(ring_size))
brain = Brain.new input, output, ring

class FreezeGame
  def initialize odds_of_look=0.1
    @odds_of_look = odds_of_look
  end

  def cycle
  end
end
