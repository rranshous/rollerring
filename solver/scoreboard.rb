require_relative 'array_patch'
require 'ostruct'
require 'set'
require 'pry'
require 'binary_search/native'

class Scoreboard

  def initialize max_size = 1000
    @scores = []
    @individuals = []
    @max_size = max_size
  end

  def scores
    @scores.zip(@individuals).map{ |(s, i)| OpenStruct.new(score: s, individual: i) }
  end

  def add_score individual, score
    # TODO: non linear scaling
    best = @scores.first
    if best.nil? || score <= best
      if !best.nil? && score < best
        puts
        puts "NEW [#{score}]: #{individual}"
      end
      insert_score individual, score
      delete_low_scorer
    end
  end

  private

  def delete_low_scorer
    if @scores.length > @max_size
      worst = @scores.last
      # TODO: these are sorted, we can do better than select
      low_scorers = @scores.select{ |s| s == worst }
      index = @scores.binary_index(low_scorers.sample)
      @scores.delete_at index
      @individuals.delete_at index
    end
  end

  def insert_score individual, score
    index = insert_index(score)
    @scores.insert(index, score)
    @individuals.insert(index, individual)
  end

  def insert_index score
    index = @scores.binary_index(score)
    # no direct match
    if index.nil?
      value = @scores.bsearch { |v| v >= score }
      # no #'s larger
      if value.nil?
        index = @scores.length
      else
        index = @scores.binary_index(value)
      end
    end
    if index == 0
      0
    else
      # index will be an instance of the #, we need
      # to walk back to the first one though
      value = @scores[index]
      start = value
      # walk til we hit the begining or we find a lower #
      while @scores[index-1] == start && index > 0
        index -= 1
      end
      index
    end
  end
end

