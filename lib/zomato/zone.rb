module Zomato
  class Zone
    
    attr_reader :id, :name, :city_id
    
    def self.build(response)
      response['zones'].collect do |zone|
        Zone.new(zone['zone'])
      end
    end
    
    def initialize(attributes)
      @id = attributes['zone_id']
      @name = attributes['name']
      @city_id = attributes['city_id'].to_i
    end
    
    def subzones
      response = Api.get('/subzones', :query => {:zone_id => id}).parsed_response
      Subzone.build(response, city_id)
    end
    
    def restaurants
      query = {:city_id => city_id, :zone_id => id}
      response = Api.get('/search', :query => query).parsed_response
      Restaurant.build(response, query)
    end
    
  end
end