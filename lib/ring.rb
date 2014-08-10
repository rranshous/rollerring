require_relative 'roller'

class Ring
  def initialize ring
    @ring = ring
    @rollers = {
      Roller.new => 0
    }
    @steps = nil
    @max_rollers = 10
    @last_run = nil
  end

  # TODO: break up so that search is not nec and can be externally stepped
  def run start=0, max_cycles=99999999, input_buffer=[], search=nil
    #puts "Running: #{@ring}"
    output_buffer = []
    (0..max_cycles).each do |cycle|
      break if !search.nil? && output_buffer.length >= search.length
      @rollers.keys.each_with_index do |roller, roller_index|
        index = @rollers[roller]
        cell_value = @ring[index]
        # if we hit the end cell, we're done
        #puts "Ring: #{@ring.join('|')}"
        #puts "IN: #{input_buffer}"
        #puts "OUT: #{output_buffer}"
        #puts "Cell [#{index}]: |#{cell_value}| " \
        #     "<#{roller_index}|#{roller.object_id}> [#{cycle}]"
        if cell_value == 'fork'
          state = roller.dump_state
          step = state[:step]
          #puts "OLD STEP: #{step}"
          #puts "ROLLERS: #{@rollers.length} :: #{@max_rollers}"
          # don't fork if we hit max forks
          # if we don't have a step, dont fork
          if step != :next_numeric && @rollers.length < @max_rollers
            state[:step] = :next_numeric
            @rollers[Roller.new(state)] = (index+step.to_i).abs % @ring.length
            #puts "NEW ROLLER: #{@rollers.values.last}"
          end
        else
          new_cell_value, step = roller.run cell_value, input_buffer, output_buffer
          if new_cell_value == 'end'
            #puts "ending roller #{roller_index}"
            @rollers.delete(roller)
            break
          end
          if new_cell_value != cell_value
            @ring[index] = new_cell_value
            #puts "RING: #{@ring}"
          end
        end
        if step == :next_numeric
          step = 1
        end
        index += step.to_i
        index = index.abs # wrap around neg steps
        index %= @ring.length
        @rollers[roller] = index
      end
    end
    output_buffer.map(&:to_s)
  end
end


