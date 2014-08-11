require_relative '../lib'
class Mutator
  def self.mutate individual
    possible_values = RingGen.possible_values
    individual = individual.dup
    # chance to mutate
    if rand(100) == 0
      individual = individual.tap do |result|
        [(result.length * 0.01).to_i, 1].max.times do
          result[rand(result.length)] = possible_values.sample
        end
      end
    end
    # chance to lose a bit
    if rand(100) == 0
      index = rand(individual.length)
      individual.delete_at index
    end
    # chance to gain a bit
    if rand(100) == 0
      index = rand(individual.length)
      individual.insert index, possible_values.sample
    end
    individual
  end
end
