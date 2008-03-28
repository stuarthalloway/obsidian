require File.join(File.dirname(__FILE__), "/../../test_helper")

describe "DatingService" do
   
  it "makes birds and bees happy" do
    bird = Bird.create(:name => "Big")
    bee = Bee.create(:name => "Buzzy")
    assert_models_updated(Bird,Bee) do
      DatingService.date(bird,bee)
    end
  end
  
end