class Roller

  def initialize action_states={}

    # order matters
    @actions = {
      step: 1,
      input: false,
      multiply: false,
      divide: false,
      add: false,
      subtract: false,
      gt: false,
      lt: false,
      output: false,
      place: false,
      toinput: false
    }.update(action_states)

    @action_defaults = {
      step: :next_numeric,
      input: true,
      multiply: :next_numeric,
      divide: :next_numeric,
      add: :next_numeric,
      subtract: :next_numeric,
      gt: :next_numeric,
      lt: :next_numeric,
      output: true,
      place: true,
      toinput: true
    }
  end

  def dump_state
    @actions.dup
  end

  def possible_actions
    @actions.keys.map(&:to_s) + ['end','fork','noop']
  end

  def run value, input_buffer, output_buffer
   # puts "ACTIONS: #{@actions}"
    return [value, @actions[:step]] if value == 'noop'
    original_value = value
    @actions.each do |action, action_state|
      value, new_state = take_action(action, action_state, value,
                                     input_buffer, output_buffer)
      #puts "V: #{value} :: N: #{new_state}"
      @actions[action] = new_state
    end
    #puts "POSTACTIONS: #{@actions}"
    step = @actions[:step]
    if step == @action_defaults[:step]
      step = 1
    else
      step = step.to_i
    end
    if @actions[:place] == true
      [value.to_s, step]
    else
      [original_value, step]
    end
  end

  private

  def is_numeric?(value)
    value.to_s.to_i.to_s == value.to_s
  end

  def take_action action, action_state, value,
                  input_buffer, output_buffer

    if action_state != false

      # if we hit an action that is on, than we reset it
      if value == action.to_s
        default = @action_defaults[action]
        if default == true
          default = false
        end
        [value, default]

      # we don't take action against action values
      elsif is_numeric?(value)

        if action_state == :next_numeric
          [value, value]

        else
          #puts action
          #puts "Action: #{action} :: #{action_state} :: #{value}"
          result = self.send(action.to_sym, action_state, value,
                             input_buffer, output_buffer)
          # limit the number's max size
          case result[0]
          when Integer, Float
            [[-99999999, [99999999, result[0]].min].max, result[1]]
          else
            result
          end
        end

      # if it's not numeric, i don't care
      else
        [value, action_state]
      end

    # if the action is off but we hit that action
    # as an input than we want to flip it on
    elsif value == action.to_s
      default = @action_defaults[action]
      if default == :next_numeric and is_numeric?(value)
        [value, value]
      else
        [value, default]
      end

    else
      [value, action_state]
    end

  end

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
  end
end

