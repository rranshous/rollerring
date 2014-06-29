require_relative 'random_bus'

class GeneticBus < RandomBus
  def initialize birther, mater, mutator, max_population
    super birther, max_population
    self.mater = mater
    self.mutator = mutator
  end

  def refill seed_individuals
    return super() if seed_individuals.length == 0
    # leave one space for a rando
    @passengers = (max_population - 1).times.map do
      mutator.mutate(
        mater.mate seed_individuals.sample, seed_individuals.sample
      )
    end
    # inject rando
    super()
  end

  private
  attr_accessor :mater, :mutator
end
