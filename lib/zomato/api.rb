require 'httparty'

module Zomato

  class Api
    
    include HTTParty
    format :json
    base_uri 'https://api.zomato.com/v1/'
    default_params :format => 'json'
    
  end
  
end