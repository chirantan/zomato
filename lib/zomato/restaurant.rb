module Zomato
  class Restaurant
    
    class Collection
      attr_reader :results_found, :results_start, :results_shown, :restaurants
      
      def initialize(response, query)
        load(response, query)
      end
      
      def total_pages
        (results_found.to_i / results_shown.to_f).ceil
      end
      
      def next_page!
        return self unless has_next_page?
        @results_start = next_page_result_start 
        @query.merge({:start => results_start, :count => results_shown})
        response = Api.get('/search', :query => @query).parsed_response
        load(response, @query)
      end
      
      def previous_page!
        return self unless has_previous_page?
        @results_start = previous_page_result_start
        @query.merge({:start => results_start, :count => results_shown})
        response = Api.get('/search', :query => query).parsed_response
        load(response, @query)
      end
      
      def has_next_page?
        next_page_result_start <= results_found.to_i
      end
      
      def has_previous_page?
        previous_page_result_start >= 0
      end
      
      def attributes
        {
          :results_found => @results_found,
          :results_start => @results_start,
          :results_shown => @results_shown,
          :resturants    => @restaurants,
          :query         => @query
        }
      end
      
      def first; restaurants.first end
      def last;  restaurants.last  end
      
      private
      
      def previous_page_result_start
        results_start.to_i - results_shown.to_i - 1
      end
      
      def next_page_result_start
        results_start.to_i + results_shown.to_i + 1
      end
      
      def load(response, query)
        @query = query || {}
        @results_found = response['resultsFound']
        @results_start = response['resultsStart']
        @results_shown = response['resultsShown']
        @restaurants   = response['results'].collect do |restaurant|
          Restaurant.new(restaurant['result'])
        end
      end
      
    end
    
    attr_reader :id, :name, :address, :locality, :city, :cuisines, :rating_editor_overall, :cost_for_two, :has_discount, :has_citibank_discount
    
    def initialize(attributes)
      @id                    = attributes['id'].to_i
      @name                  = attributes['name']
      @address               = attributes['address']
      @locality              = attributes['locality']
      @city                  = attributes['city']
      @cuisines              = attributes['cuisines']
      @rating_editor_overall = attributes['rating_editor_overall']
      @cost_for_two          = attributes['cost_for_two']
      @has_discount          = attributes['has_discount'] == 1
      @has_citibank_discount = attributes['has_citibank_discount'] == 1
      @details               = attributes['details'] if attributes['details']
    end
    
    def details
      @details ||= Api.get("/restaurant/#{id}").parsed_response
    end
    
    def reviews(query = {})
      query = {
        :start => 1,
        :count => 10
      }.merge(query)
      Api.get("/reviews/#{id}/user", :query => query).parsed_response
    end
    
    def report_error(data, name = nil)
      query = {:res_id => id, :data => data}
      query.store(:name, name) if name
      Api.post('/contact', :query => query).parsed_response['status'] == 1
    end
    
    class << self
      def build(response, query)
        Collection.new(response, query)
      end
      
      def create_by_details(details)
        attributes = {
          'details'               => details,
          'name'                  => details['name'],
          'id'                    => details['id'],
          'address'               => details['location']['address'],
          'locality'              => details['location']['locality'],
          'city'                  => details['location']['city'],
          'cuisines'              => details['cuisines'],
          'rating_editor_overall' => details['editorRating']['overall'],
          'cost_for_two'          => details['avgCostForTwo']
        }
        Restaurant.new(attributes)
      end
      
      def search(city_id, search_term, dish, name, cuisine, address, query = {})
        query = {
          :city_id  => city_id,
          :q        => search_term,
          :qdish    => dish,
          :qname    => name,
          :qcuisine => cuisine,
          :qaddress => address
        }.merge(query)
        response = Api.get("/search", :query => query).parsed_response
        Restaurant.build(response, query)
      end
      
      def near(lat, lon, query = {})
        query = {
          :lat        => lat,
          :lon        => lon,
          :random     => true
        }.merge(query)
        create_by_details(Api.get("/search/near", :query => query).parsed_response)
      end
      
    end
    
  end
end


