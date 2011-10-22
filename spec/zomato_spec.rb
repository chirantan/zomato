require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Zomato do
  
  before(:each) do
    @zomato = Zomato::Base.new('4e9991c4a7f431322011964e9991c4a7') 
  end
  
  it 'should fetch all the cities that zomato supports currently' do
    city = @zomato.cities.first
    city.id.should == 1
    city.name.should == 'Delhi NCR'
    city.longitude.should == '77.210276'
    city.latitude.should == '28.625789'
    city.has_nightlife.should be_true
    city.show_zones.should be_true
  end
  
  it 'should fetch a locality based on latitude and logitude' do
    locality = @zomato.locality('28.557706', '77.205879')
    locality.name.should == 'Green Park'
    locality.city_name.should == 'Delhi'
    locality.city_id.should == 1
  end
  
  describe 'city' do
    
    before(:each) do
      @city = @zomato.cities.first
    end
    
    it 'should fetch all the zones in a city' do
      zone = @city.zones.first
      zone.id.should == 1
      zone.name.should == 'Noida'
      zone.city_id.should == 1
    end
    
    it 'should fetch all the subzones in a city' do
      @id=316, @name="Alaknanda", @zone_id="3", @city_id=1
      subzone = @city.localities.first
      subzone.id.should == 316
      subzone.name.should == "Alaknanda"
      subzone.zone_id.should == 3
      subzone.city_id.should == 1
    end

    it 'should fetch all cuisines in a city' do
      cuisine = @city.cuisines.first
      cuisine.id.should == 1
      cuisine.name.should == 'American'
      cuisine.city_id.should == 1
    end
    
    describe 'cuisine' do
      
      before(:each) do
        @cuisine = @city.cuisines.first
      end
      
      it 'should search a restaurant based on cuisine' do
        restaurants = @cuisine.restaurants
        restaurants.results_found.should == 100
        restaurants.results_start.should == 0
        restaurants.results_shown.should == 10
        restaurants.restaurants.size.should == 10
        restaurant = restaurants.first
        restaurant.id.should == 2760
        restaurant.name.should == "Vapour"
        restaurant.address.should == "2nd Floor, MGF Mega City Mall, MG Road, Gurgaon"
        restaurant.locality.should == "MG Road"
        restaurant.city.should == "Gurgaon"
        restaurant.cuisines.should == "Continental, Asian, North Indian, Lounge, Chinese"
        restaurant.rating_editor_overall.should == 4
        restaurant.cost_for_two.should == 1500
        restaurant.has_discount.should be_false
        restaurant.has_citibank_discount.should be_false
      end
      
    end

    describe 'zone' do

      before(:each) do
        @zone = @city.zones[2]  
      end

      it 'should fetch all subzones in a zone' do
        subzone = @zone.subzones.first
        subzone.id.should == 316
        subzone.name.should == "Alaknanda"
        subzone.zone_id.should == 3
        subzone.city_id.should == 1
      end
      
      it 'should fetch all restaurants in a zone' do
        restaurants = @zone.restaurants
        restaurants.results_found.should == 100
        restaurants.results_start.should == 0
        restaurants.results_shown.should == 10
        restaurants.restaurants.size.should == 10
        restaurant = restaurants.first
        restaurant.id.should == 2760
        restaurant.name.should == "Vapour"
        restaurant.address.should == "2nd Floor, MGF Mega City Mall, MG Road, Gurgaon"
        restaurant.locality.should == "MG Road"
        restaurant.city.should == "Gurgaon"
        restaurant.cuisines.should == "Continental, Asian, North Indian, Lounge, Chinese"
        restaurant.rating_editor_overall.should == 4
        restaurant.cost_for_two.should == 1500
        restaurant.has_discount.should be_false
        restaurant.has_citibank_discount.should be_false
      end

      describe 'subzone' do
        before(:each) do
          @subzone = @zone.subzones.first
        end

        it 'should fetch all restaurants in a subzone' do
          restaurants = @subzone.restaurants
          restaurants.results_found.should == 100
          restaurants.results_start.should == 0
          restaurants.results_shown.should == 10
          restaurants.restaurants.size.should == 10
          restaurant = restaurants.first
          restaurant.id.should == 2760
          restaurant.name.should == "Vapour"
          restaurant.address.should == "2nd Floor, MGF Mega City Mall, MG Road, Gurgaon"
          restaurant.locality.should == "MG Road"
          restaurant.city.should == "Gurgaon"
          restaurant.cuisines.should == "Continental, Asian, North Indian, Lounge, Chinese"
          restaurant.rating_editor_overall.should == 4
          restaurant.cost_for_two.should == 1500
          restaurant.has_discount.should be_false
          restaurant.has_citibank_discount.should be_false
        end
      end
    end

    describe 'restaurant' do

      before(:each) do
        @restaurant = @zomato.cities.first.localities.first.restaurants.first
      end

      it 'should show details of a restaurant' do
        @restaurant.details.should be_a Hash
      end

      it 'should show reviews of a restaurant' do
        @restaurant.reviews.should be_a Hash
      end

      it 'should report error' do
        @restaurant.report_error("There was an error").should == true
      end
      
      it 'should search for restaurants' do
        restaurants = Zomato::Restaurant.search(1, 'search term', 'dish', 'name', 'cuisine', 'address')
        restaurants.results_found.should == 100
        restaurants.results_start.should == 0
        restaurants.results_shown.should == 10
        restaurants.restaurants.size.should == 10
        restaurant = restaurants.first
        restaurant.id.should == 2760
        restaurant.name.should == "Vapour"
        restaurant.address.should == "2nd Floor, MGF Mega City Mall, MG Road, Gurgaon"
        restaurant.locality.should == "MG Road"
        restaurant.city.should == "Gurgaon"
        restaurant.cuisines.should == "Continental, Asian, North Indian, Lounge, Chinese"
        restaurant.rating_editor_overall.should == 4
        restaurant.cost_for_two.should == 1500
        restaurant.has_discount.should be_false
        restaurant.has_citibank_discount.should be_false
      end
      
      it 'should search for random restaurant near given geocodes' do
        restaurant = Zomato::Restaurant.near('28.557706', '77.205879', :city_id => 1, :cuisine_id => 1)
        restaurant.id.should == 315
        restaurant.name.should == "Sagar Ratna"
        restaurant.address.should == "B-1, A-11 Mohan Co-operative Ind Area, Mathura Road, New Delhi"
        restaurant.locality.should == "Mathura Road"
        restaurant.city.should == "Delhi"
        restaurant.cuisines.should == "South Indian"
        restaurant.rating_editor_overall.should == 3
        restaurant.cost_for_two.should == 450
        restaurant.has_discount.should be_false
        restaurant.has_citibank_discount.should be_false
      end

    end
  end
end

