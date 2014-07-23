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
