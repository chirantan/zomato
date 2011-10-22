
module Zomato
  class Base
    
    def initialize(key)
      @key = key
      Api.headers 'X-Zomato-API-Key' => key
    end
    
    def cities
      @cities ||= City.build(Api.get('/cities').parsed_response)
    end
    
    def locality(lat, lon)
      response = Api.get('/geocodes', :query => {:lat => lat, :lon => lon}).parsed_response
      Locality.new(response['locality'])
    end
    
  end
end