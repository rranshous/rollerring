class Array
  def <=> other
    self.zip(other).each do |a,b|
      return a.send(:<=>, b) unless a.send(:<=>, b) == 0
    end
    0
  end
end
