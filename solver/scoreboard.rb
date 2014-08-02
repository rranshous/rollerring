require_relative 'array_patch'
require 'ostruct'
require 'set'
require 'pry'

class Scoreboard

  def initialize max_size = 1000
    @scores = SortedSet.new
    @max_size = max_size
  end

  def scores
    @scores.map{ |(s, i)| OpenStruct.new(score: s, individual: i) }
  end

  def add_score individual, score
    # TODO: non linear scaling
    raw_scores = @scores.to_a
    best = raw_scores.first
    worst = raw_scores.last
    if best.nil? || score <= best[0]
      if !best.nil? && score < best[0]
        puts
        puts "NEW [#{score}]: #{individual}"
      end
      #puts "SCORES [#{raw_scores.length}]: #{raw_scores}"
      @scores.add [score, individual]
      if raw_scores.length > @max_size
        low_scorers = raw_scores.select{|s| s[0] == worst[0]}
        @scores.delete low_scorers.sample
      end
    end
  end
end

