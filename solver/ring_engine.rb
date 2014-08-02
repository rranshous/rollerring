require_relative '../lib'
class RingEngine
  def initialize cycles
    @cycles = cycles
  end

  def run individual, input
    Ring.new(individual).run(0, @cycles, input)
  end
end

class CachingRingEngine < RingEngine
  def initialize cycles
    @cache = {}
    super
  end

  def run individual, input
    return @cache[individual] if @cache.include? individual
    cull_cache
    @cache[individual] = super
  end

  private

  def cull_cache
    @cache.delete(@cache.keys.last) if @cache.length > max_size
  end

  def max_size
    10
  end
end
