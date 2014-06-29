class Mater
  def self.mate i1, i2
    i1.zip(i2).map{ |t1,t2| [t1, t2].sample }
  end
end

