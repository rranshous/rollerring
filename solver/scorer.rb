require 'pry'
class Scorer
  def self.score correct, given
    tally = 0
    correct.zip(given).each do |c,o|
      if c == o
        tally += 3
      elsif given.include?(c)
        tally += 1
      end
    end
    tally -= (correct.length - given.length).abs
    tally
  end
end

