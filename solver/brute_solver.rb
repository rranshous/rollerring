class BruteSolver
  def initialize test_set, bus
    self.test_set = test_set
    self.bus = bus
  end

  def find_solution
    loop do
      solution = cycle_for_solution
      return solution if solution
      repopulate
      yield if block_given?
    end
  end

  private
  attr_accessor :test_set, :bus

  def cycle_for_solution
    population_stats.each do |stat|
      puts "STAT: #{stat}"
      return stat[:individual] if stat[:passes_tests]
    end
    false
  end

  def population_stats
    bus.passengers.map { |individual| stats_for individual }
  end

  def stats_for individual
    test_set.stats_for individual
  end

  def repopulate
    bus.refill
  end
end
