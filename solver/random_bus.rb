class RandomBus

  def initialize birther, max_population
    self.birther = birther
    self.max_population = max_population
    @passengers = []
  end

  def passengers
    @passengers
  end

  def refill
    @passengers = max_population.times.map { birther.grow }
  end

  private
  attr_accessor :max_population, :birther
end
