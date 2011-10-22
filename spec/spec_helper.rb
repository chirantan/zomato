require 'rubygems'
require 'fakeweb'
require File.expand_path(File.dirname(__FILE__) + '/../lib/zomato.rb')

FakeWeb.allow_net_connect = %r[^https?://localhost]
FakeWeb.register_uri(
  :get, "https://api.zomato.com/v1/cities?format=json",
  :body => File.open(File.dirname(__FILE__) + '/responses/cities.json').read
)
FakeWeb.register_uri(
  :get, "https://api.zomato.com/v1/geocodes?format=json&lat=28.557706&lon=77.205879",
  :body => File.open(File.dirname(__FILE__) + '/responses/locality.json').read
)
FakeWeb.register_uri(
  :get, "https://api.zomato.com/v1/zones?format=json&city_id=1",
  :body => File.open(File.dirname(__FILE__) + '/responses/zones.json').read
)
FakeWeb.register_uri(
:get, %r|https://api.zomato.com/v1/subzones*|,
  :body => File.open(File.dirname(__FILE__) + '/responses/subzones.json').read
)
FakeWeb.register_uri(
  :get, %r|https://api.zomato.com/v1/search?.*|,
  :body => File.open(File.dirname(__FILE__) + '/responses/restaurants.json').read
)
FakeWeb.register_uri(
  :get, %r|https://api.zomato.com/v1/cuisines*|,
  :body => File.open(File.dirname(__FILE__) + '/responses/cuisines.json').read
)
FakeWeb.register_uri(
  :get, %r|https://api.zomato.com/v1/restaurant/*|,
  :body => File.open(File.dirname(__FILE__) + '/responses/restaurant.json').read
)
FakeWeb.register_uri(
  :get, %r|https://api.zomato.com/v1/reviews/.*/user*|,
  :body => File.open(File.dirname(__FILE__) + '/responses/reviews.json').read
)
FakeWeb.register_uri(
  :post, %r|https://api.zomato.com/v1/contact*|,
  :body => File.open(File.dirname(__FILE__) + '/responses/report_error.json').read
)
FakeWeb.register_uri(
:get, "https://api.zomato.com/v1/search/near?city_id=1&cuisine_id=1&format=json&lat=28.557706&lon=77.205879&random=true",
  :body => File.open(File.dirname(__FILE__) + '/responses/restaurant.json').read
)






