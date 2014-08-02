require_relative '../lib'
class RingEngine
  def initialize cycles
    @cycles = cycles
  end

  def run individual, input
    Ring.new(individual).run(0, @cycles, input)
  end
end

# TODO: cap cache size
class CachingRingEngine < RingEngine
  def initialize cycles
    @cache = {}
    super
  end

  def run individual, input
    return @cache[individual] if @cache.include? individual
    @cache[individual] = super
  end
end
