require_relative '../lib'
class RingEngine
  def initialize cycles
    @cycles = cycles
  end

  def run individual, input
    Ring.new(individual).run(0, @cycles, input)
  end
end
