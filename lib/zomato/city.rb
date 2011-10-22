module Zomato
  class City
    
    attr_reader :id, :name, :longitude, :latitude, :has_nightlife, :show_zones
    
    class << self
      
      def build(response)
        @cities ||=
        response['cities'].collect do |city|
          City.new(city['city'])
        end
      end
      
    end
    
    def initialize(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @longitude = attributes['longitude']
      @latitude = attributes['latitude']
      @has_nightlife = attributes['has_nightlife'] == 1
      @show_zones = attributes['show_zones'] == 1
    end
    
    def zones
      response = Api.get(
        '/zones', 
        :query => {:city_id => id}
      ).parsed_response
      Zone.build(response)
    end
    
    def localities
      response = Api.get(
        '/subzones', 
        :query => {:city_id => id}
      ).parsed_response
      Subzone.build(response, id)
    end
    
    def cuisines
      response = Api.get(
        '/cuisines', 
        :query => {:city_id => id}
      ).parsed_response
      Cuisine.build(response, id)
    end
    
  end
end