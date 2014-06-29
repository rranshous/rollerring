require 'pry'
class Scorer
  def self.score correct, given
    tally = 0
    correct.zip(given).each do |c,o|
      if c == o
        tally += 5
      elsif given.include?(c)
        tally += 1
      end
    end
    tally
  end

  def self.max_score correct
    correct.length * 5
  end
end

