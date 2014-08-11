class Mater

  def self.mate i1, i2
    #self.crossover i1, i2
    self.uniform_crossover i1, i2
  end

  def self.uniform_crossover i1, i2
    indexes = []
    [(i1.length/5),1].max.times do
      while !indexes.include?(index = rand(i1.length))
        indexes << index
      end
    end
    indexes.sort!
    child = []
    prev_index = 0
    parent = i1
    indexes.each do |index|
      child[prev_index..index] = parent[prev_index..index]
      if parent == i1
        parent = i2
      else
        parent = i1
      end
      prev_index = index
    end
    if prev_index != i1.length - 1
      child[prev_index..-1] = parent[prev_index..-1]
    end
    child
  end

  def self.crossover i1, i2
    index = rand(i1.length)
    parents = [i1, i2].sample(2) # randomize parent order
    parents.first[0...index] + parents.last[index..-1]
  end

  def self.linear_mate i1, i2
    i1.zip(i2).map{ |t1,t2| [t1, t2].sample }
  end
end

