require_relative 'brute_solver'
require_relative '../lib/worker'

module ParallelSolver

  private

  def population_stats
    @workers ||= create_workers
    bus.passengers.each_slice(bus.max_population).map do |individuals|
      r = Worker.map(@workers, individuals)
    end.flatten
  end

  def create_workers
    bus.max_population.times.map do
      Worker.new do |individual|
        stats_for individual
      end
    end
  end
end
