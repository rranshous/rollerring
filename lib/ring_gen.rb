class RingGen
  def self.random length=2000
    possibles = Roller.new.possible_actions + (0..9).map(&:to_s)
    [].tap do |result|
      length.times do
        result << possibles.sample
      end
    end
  end
end

