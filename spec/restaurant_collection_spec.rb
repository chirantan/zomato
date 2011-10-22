require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Zomato::Restaurant::Collection do
  
  before(:each) do
    query = {:city_id => 1, :zone_id => 1}
    response = Zomato::Api.get('/search').parsed_response
    @zomato_restaurant_collection = Zomato::Restaurant::Collection.new(response, query)
  end
  
  it 'should handle pages correctly' do
    @zomato_restaurant_collection.total_pages.should == 10
    @zomato_restaurant_collection.has_next_page?.should be_true
    @zomato_restaurant_collection.has_previous_page?.should be_false
    @zomato_restaurant_collection.next_page!
    @zomato_restaurant_collection.should_receive(:results_found).at_least(1).times.and_return(100)
    @zomato_restaurant_collection.should_receive(:results_start).at_least(1).times.and_return(11)
    @zomato_restaurant_collection.should_receive(:results_shown).at_least(1).times.and_return(10)
    @zomato_restaurant_collection.results_start.should == 11
    @zomato_restaurant_collection.has_previous_page?.should be_true
    @zomato_restaurant_collection.has_next_page?.should be_true
  end
end