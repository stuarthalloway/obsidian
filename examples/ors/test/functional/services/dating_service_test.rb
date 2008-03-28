require File.join(File.dirname(__FILE__), "/../../test_helper")

describe "DatingService" do
   
  describe "Demonstrate non-transactional scenario" do
    it "makes birds and bees happy" do
      bird = Bird.create(:name => "Big")
      bee = Bee.create(:name => "Buzzy")
      assert_models_updated(Bird,Bee) do
        DatingService.date(bird,bee)
      end
    end
  end
  
  describe "Demonstrate transaction rollback" do
    it "doesn't always work out" do
      bird = Bird.create(:name => "Big")
      bee = Bee.create(:name => "Buzzy")
      assert_no_models_updated do
        lambda{DatingService.bad_date(bird,bee)}.should.raise(RuntimeError)
      end
    end
  end
end