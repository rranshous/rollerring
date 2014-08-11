class Mater

  def self.mate i1, i2
    case rand(3)
    when 0
      [i1, i2].sample
    when 1
      self.uniform_crossover i1, i2
    when 2
      self.linear_mate i1, i2
    end
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
    p1, p2 = [i1, i2].sample(2)
    index = rand(p1.length)
    puts "LEN: #{p1.length} :: INDEX: #{index}"
    puts "PARENTS: #{p1} :: #{p2}"
    p1[0...index] + p2[([p2.length-1,index].min)...-1]
  end

  def self.linear_mate i1, i2
    t = [i1.length, i2.length].min
    i1.take(t).zip(i2.take(t)).map{ |t1,t2| [t1, t2].sample }
  end
end

