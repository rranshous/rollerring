require 'timeout'
require 'pp'

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
      output: false,
      place: false
    }.update(action_states)

    @action_defaults = {
      step: :next_numeric,
      input: true,
      multiply: :next_numeric,
      divide: :next_numeric,
      add: :next_numeric,
      subtract: :next_numeric,
      output: true,
      place: true
    }
  end

  def dump_state
    @actions.dup
  end

  def possible_actions
    @actions.keys.map(&:to_s) + ['end','fork','noop']
  end

  def run value, input_buffer, output_buffer
    #puts "ACTIONS: #{@actions}"
    return [value, @actions[:step]] if value == 'noop' 
    original_value = value
    @actions.each do |action, action_state|
      value, new_state = take_action(action, action_state, value,
                                     input_buffer, output_buffer)
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

  def step current_step, value, *args
    [value, current_step]
  end

  def place to_place, value, *args
    [value, true]
  end
end

class Ring
  def initialize ring
    @ring = ring
    @rollers = {
      Roller.new => 0
    }
    @steps = nil
    @max_rollers = 10
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
        if cell_value == 'end'
          #puts "ending roller #{roller_index}"
          @rollers.delete(roller)
          break
        end
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
          if new_cell_value != cell_value
            @ring[index] = new_cell_value
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

forker = '2|input|4|skip|2|1|1|fork|2|3|2'.split('|')
placer = 'place|add|2|2|3|4|'.split('|')
outputer = 'place|add|2|2|3|4|output|2|1|1|1|9'.split('|')

class RingGen
  def self.random length=2000
    possibles = Roller.new.possible_actions + (0..9).map(&:to_s)
    [].tap do |result|
      length.times do
        result << possibles.sample
      end
    end
  end
end

class Grower
  def initialize search, input_buffer=[], pop_size=100, ring_size=250, cycles=1000
    @search = search
    @input_buffer = input_buffer
    puts "SEARCH [#{perfect_score}]: #{input_buffer} =>  #{search}"
    @target_population_size = pop_size
    @ring_size = ring_size
    @cycles = cycles
    @population = {}
    @population_cycles = 0
  end

  def seed_population
    @population[0] ||= []
    diff = under_population_diff
    if diff > 0
      puts "Seeding: #{diff}"
      diff.times do
        @population[0] << RingGen.random(@ring_size)
      end
    end
  end

  def under_population_diff
    @target_population_size - population_size
  end

  def population_diff
    (@target_population_size - population_size).abs
  end

  def population_size
    @population.values.flatten(1).length
  end

  def run
    while !match_found?
      puts "---- #{@population_cycles}"
      puts "Pop: #{population_size}"
      puts "Best: #{best_score}"
      puts "Perfect: #{perfect_score}"
      puts "Over0: #{@population.keys.select{|k| k>0}.map{|k| @population[k].length}.reduce(&:+)}"
      seed_population
      puts "Cycling"
      cycle
      cull
      mate
      mutate!
      @population_cycles += 1
    end
    if match_found?
      puts "---- #{@population_cycles}"
      puts "Pop: #{population_size}"
      puts "Best: #{best_score}"
      puts "Perfect: #{perfect_score}"
      puts "Over0: #{@population.keys.select{|k| k>0}.map{|k| @population[k].length}.reduce(&:+)}"
      puts "MATCHED!: #{best_score}"
      puts "#{@population[best_score]}"
    end
  end

  def best_score
    @population.keys.sort.last
  end

  def cull
    # cut bottom half
    diff = population_size - (@target_population_size * 0.8).to_i
    deleted = []
    if diff > 0
      puts "Culling: #{diff}"
      diff.times do
        lowest = @population.keys.sort.first
        individuals = @population[lowest]
        len = individuals.length
        if len > 0
          individuals.delete_at(rand(len))
        else
          @population.delete(lowest)
        end
      end
    end
  end

  def mate
    diff = population_diff
    puts "MATING: #{diff}"
    count = 0
    @population.keys.sort.reverse.each do |score|
      break if score < 1
      individuals = @population[score]
      score.times do
        break if count > diff
        individuals.sample(individuals.length / 3)
        .zip(individuals.sample(individuals.length / 3))
        .each do |i1, i2|
          new_individual = i1.zip(i2).map{ |t1,t2| [t1, t2].sample }
          @population[0] ||= []
          @population[0] << new_individual
          count += 1
        end
      end
    end
    puts "MATED: #{count}"
  end

  def mutate!
    # mutate 1% of pop
    mutate_count = (population_size * 0.02).to_i
    puts "Mutating! #{mutate_count}"
    possible_actions = Roller.new.possible_actions
    @population.values.flatten(1).sample(mutate_count).each do |individual|
      (individual.length * 0.01).to_i.times do
        individual[rand(individual.length-1)] = possible_actions.sample
      end
    end
  end

  def mutate
    possible_actions = Roller.new.possible_actions
    diff = population_diff
    count = 0
    @population.keys.sort.reverse.each do |score|
      next if score < 1
      score.times do
        break if count > diff
        individual = @population[score].sample
        if individual
          child = individual.dup
          (child.length * 0.1).to_i.times do
            child[rand(individual.length-1)] = possible_actions.sample
          end
          @population[0] ||= []
          @population[0] << child
          count += 1
        end
      end
    end
    puts "MUTATED: #{count}"
  end

  def match_found?
    (@population[perfect_score] || []).length > 0
  end

  def perfect_score
    @perfect_score ||= score(@search)
  end

  def cycle
    count = 0
    @population.keys.each do |score|
      @population[score].length.times do
        #print '.' if count % 10 == 0
        individual = @population[score].shift
        output = cycle_individual(individual)
        new_score = score(output)
        @population[new_score] ||= []
        @population[new_score] << individual
        count += 1
      end
    end
  end

  def cycle_individual individual
    Timeout::timeout(0.5) do
      Ring.new(individual).run(0, @cycles, @input_buffer.dup, @search)
    end
  rescue Timeout::Error
    puts "TIMEOUT!"
    []
  end

  private

  def score output
    tally = 0
    @search.zip(output).each do |s, o|
      tally += 5 if s == o
      tally += 1 if output.include?(s)
    end
    tally
  end
end
