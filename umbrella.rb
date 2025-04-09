# Write your solution below!
require "http"
require "json"
require "dotenv/load"

puts "Will you need an umbrella today?"
puts "Where are you?"
location = gets.chomp
#location = "Chicago Loop Millenium Park"
location = location.gsub(" ","%20")
google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json" + "?address=#{location}"+"&key=#{ENV.fetch("GMAPS_KEY")}"
maps_response_raw = HTTP.get(google_maps_url)
maps_response_parsed = JSON.parse(maps_response_raw)
#pp maps_response_parsed.fetch("results")[0]
pp lat = maps_response_parsed.fetch("results")[0].fetch("geometry").fetch("location").fetch("lat")
pp long = maps_response_parsed.fetch("results")[0].fetch("geometry").fetch("location").fetch("lng")


#pirate_weather_url
