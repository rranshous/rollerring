class BruteSolver
  def initialize test_set, bus
    self.test_set = test_set
    self.bus = bus
  end

  def find_solution
    loop do
      solution = cycle_for_solution
      return solution if solution
      yield if block_given?
    end
  end

  private
  attr_accessor :test_set, :bus

  def cycle_for_solution
    repopulate
    each_individual do |individual|
      return individual if passes_tests? individual
    end
    false
  end

  def each_individual
    bus.passengers.each do |individual|
      yield individual
    end
  end

  def passes_tests? individual
    test_set.passes? individual
  end

  def repopulate
    bus.refill
  end
end
