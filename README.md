# Zomato
_Ruby gem that wraps [Zomato API](http://www.zomato.com/api/documentation)_

In your Gemfile

```ruby 
gem 'zomato'
```

```bash 
$ bundle install
```

and...

```ruby 
require 'rubygems'
require 'zomato'

zomato = Zomato::Base.new('your_key_here')
delhi = zomato.cities.first 
#<Zomato::City:0x8ffe080 @id=1, @name="Delhi NCR", @longitude="77.210276", @latitude="28.625789", @has_nightlife=true, @show_zones=true>
noida = delhi.zones.first
#<Zomato::Zone:0x9b6d8bc @id=1, @name="Noida", @city_id=1>
alaknanda = delhi.localities.first 
#<Zomato::Subzone:0x8c67020 @id=316, @name="Alaknanda", @zone_id=3, @city_id=1>
american = delhi.cuisines.first
#<Zomato::Cuisine:0x94c0c58 @id=1, @name="American", @city_id=1>
restaurants = american.restaurants
restaurants.results_found # 100
restaurants.results_start # 0
restaurants.results_shown # 10
underdogs =  restaurants.restaurants.first # or
underdogs =  restaurants.first
#<Zomato::Restaurant:0x8e90694 @id=3384, @name="Underdoggs Sports Bar & Grill", @address="F 38, Level 1, Ambience Mall, Vasant Kunj, New Delhi", @locality="Vasant Kunj", @city="Delhi", @cuisines="American, Mediterranean, Italian", @rating_editor_overall=3.5, @cost_for_two=1500, @has_discount=false, @has_citibank_discount=false>

noida.restaurants
alaknanda.restaurants 
# Like for cuisines, fetches restaurants in "Noida" zone and "Alaknanda" subzone respectively

underdogs.details
underdogs.reviews
# Returns details and reviews as a hash, check zomato documentation for details as the response is returned as is.
 
underdogs.report_error("This is a test, please ignore.", "Chirantan Rajhans") # true or false based on success or failure.

searched_underdogs = Zomato::Restaurant.search(delhi.id, 'underdog').restaurants.first
# Check zomato documentation for more search options (to be passed as a hash to Zomato::Restaurant.search
searched_underdogs.id == underdogs.id # true

Zomato::Restaurant.near('28.557706', '77.205879')
# Finds a random restaurant near given geocodes.
```

### Note

* Some methods accept optional parameters (e.g. searches). Pass them as a hash. Refer zomato's documentation to know their names and datatypes.
* Also, this gem could use some more specs.

