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
    diff = max_population - @passengers.length
    @passengers = diff.times.map { birther.grow }
  end

  private
  attr_accessor :max_population, :birther
end
