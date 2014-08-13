require_relative 'brute_solver'
require_relative '../lib/worker'

module ParallelSolver

  private

  def population_stats
    @worker_pool ||= create_workers
    @worker_pool.map bus.passengers
  end

  def create_workers
    WorkerPool.new do |individual|
      stats_for individual
    end
  end
end
