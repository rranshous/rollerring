class Roller
  module Operations

    def multiply multiplier, value, *args
      [value.to_i * multiplier.to_i, multiplier]
    end

    def divide divider, value, *args
      if divider.to_i == 0
        [value, false]
      else
        [value.to_i / divider.to_i, divider]
      end
    end

    def add to_add, value, *args
      [value.to_i + to_add.to_i, to_add]
    end

    def subtract to_subtract, value, *args
      [value.to_i - to_subtract.to_i, to_subtract]
    end

    def input _on, value, input_buffer, _output_buffer
      # we are always overwriting, if there is nothing
      # in the buffer we throw down a 0
      [input_buffer.shift || 0, true]
    end

    def output _on, value, _input_buffer, output_buffer
      output_buffer << value
      [value, true]
    end

    def gt gt_value, value, _in, _out
      if value.to_f > gt_value.to_f
        [value, gt_value]
      else
        [0, gt_value]
      end
    end

    def lt lt_value, value, _in, _out
      if value.to_f < lt_value.to_f
        [value, lt_value]
      else
        [0, lt_value]
      end
    end

    def step current_step, value, *args
      [value, current_step]
    end

    def place to_place, value, *args
      [value, true]
    end

    def toinput _v, value, input, output
      input << value
      [value, true]
    end
  end
end
