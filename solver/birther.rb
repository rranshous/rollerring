require_relative '../lib'

class Birther
  def initialize length
    @length = length
  end

  def grow
    RingGen.random @length
  end
end

