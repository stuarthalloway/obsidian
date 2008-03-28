module DatingService
  
  def self.date(bird,bee)
    bird.increment!(:happy_moments)
    bee.increment!(:happy_moments)
  end

  def self.bad_date(bird,bee)
    Bird.transaction do
      bird.increment!(:happy_moments)
      raise "Ugly Bee"
    end
  end  
end