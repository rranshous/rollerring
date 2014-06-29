require_relative '../lib'
class Mutator
  def self.mutate individual
    possible_actions = Roller.new.possible_actions
    individual.dup.tap do |result|
      [(result.length * 0.01).to_i, 1].max.times do
        result[rand(result.length-1)] = possible_actions.sample
      end
    end
  end
end
