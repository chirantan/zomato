module Zomato
  class Locality
    
    attr_reader :name, :city_name, :city_id
    
    def initialize(attributes)
      @name = attributes['name']
      @city_name = attributes['city_name']
      @city_id = attributes['city_id']
      
    end
    
  end
end