class Scorer
  def self.score correct, given
    return 999999 if given == []
    correct = correct.dup
    given = given.dup
    tally = 0
    [given.length, correct.length].max.times.map do
      c = correct.shift
      g = given.shift
      if c == g
        0
      else
        1
      end
    end.reduce(&:+)
  end

  def self._score correct, given
    tally = 0
    correct.zip(given).each do |c,o|
      if c == o
        tally += 3
      elsif given.include?(c)
        tally += 1
      end
    end
    tally -= (correct.length - given.length).abs
    tally * -1
  end
end

