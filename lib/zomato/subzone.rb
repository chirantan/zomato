module Zomato
  class Subzone
    
    attr_reader :id, :name, :zone_id, :city_id
    
    class << self
      
      def build(response, city_id)
        @subzones ||=
        response['subzones'].collect do |subzone|
          Subzone.new(subzone['subzone'], city_id)
        end
      end
      
    end
    
    def initialize(attributes, city_id)
      @id = attributes['subzone_id']
      @name = attributes['name']
      @zone_id = attributes['zone_id'].to_i
      @city_id = city_id.to_i
    end
    
    def restaurants
      query = {:city_id => city_id, :subzone_id => id}
      response = Api.get('/search', :query => query).parsed_response
      Restaurant.build(response, query)
    end
    
  end

end
