module DatingService
  
  def self.date(bird,bee)
    bird.increment!(:happy_moments)
    bee.increment!(:happy_moments)
  end
  
end