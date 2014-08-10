require_relative 'roller/operations'

class Roller

  def initialize action_states={}

    @operations = Roller::Operations.new

    @actions = @operations.initial_values.update(action_states)
    #puts "ACTIONS: #{@actions}"
    @action_defaults = Hash[@operations.type_values.to_a.map do |op, value|
      [op, case value
           when 'numeric'
             :next_numeric
           when 'bool'
             true
           end
      ]
    end]
    #puts "DEFAULTS: #{@action_defaults}"
  end

  def dump_state
    @actions.dup
  end

  def possible_actions
    @actions.keys.map(&:to_s) + ['end','fork','noop']
  end

  def run value, input_buffer, output_buffer
    #puts
    #puts "RUNNING: #{value}"
    return [value, @actions[:step]] if value == 'noop'
    original_value = value
    @actions.each do |action, action_state|
      value, new_state = take_action(action, action_state, value,
                                     input_buffer, output_buffer)
      #puts "#{action.to_s.ljust(20)}: V: #{value} :: N: #{new_state}"
      @actions[action] = new_state
    end
    #puts "POSTACTIONS: #{@actions}"
    #puts "final value: #{value}"
    step = @actions[:step]
    if step == @action_defaults[:step]
      step = 1
    else
      step = step.to_i
    end
    if value == 'end'
      ['end', step]
    elsif @actions[:place] == true
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

    #puts "take action: #{action}"

    if action_state != false

      # if we hit an action that is on, than we reset it
      if value == action.to_s
        #puts "reset"
        default = @action_defaults[action]
        # WHY?!?! TODO figure that shit out
        if default == true
          default = false
        end
        [value, default]

      # we only take actions against numbers
      elsif is_numeric?(value)

        #puts 'numeric'

        if action_state == :next_numeric
          [value, value]

        else
          #puts action
          #puts "Action: #{action} :: #{action_state} :: #{value}"
          result = @operations.run_op(action.to_sym, action_state, value,
                                     input_buffer, output_buffer)
          # limit the number's max size
          #puts "RESULT: #{result} :: #{result.class}"
          case result[0]
          when Integer, Float
            [[-99999999, [99999999, result[0]].min].max, result[1]]
          else
            result
          end
        end

      # if it's not numeric, i don't care
      else
        #puts 'dont care'
        [value, action_state]
      end

    # if the action is off but we hit that action
    # as an input than we want to flip it on
    elsif value == action.to_s
      #puts 'turn on'
      default = @action_defaults[action]
      #puts "default: #{default}"
      if default == :next_numeric and is_numeric?(value)
        #puts 'setting numeric'
        [value, value]
      else
        [value, default]
      end

    else
      [value, action_state]
    end

  end

end

